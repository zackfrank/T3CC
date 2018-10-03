class Computer < ApplicationRecord
  belongs_to :game, required: false
  validates :name, presence: false
  validates :symbol, presence: false
 
  # selected_response() notes:
  # 
  # Returns a human-like response to the frontend depending on where
  # gameplay is at (ie. game is starting, middle of game, game ends)
  # 
  # First condition is computer message when game is started:
    # Available spaces is 8 rather than 9 because this method will always be called
    # AFTER the first move is made, in the as_json when sending data back to frontend
  def selected_response(game)
    if game.board.available_spaces.length == 8
      response = "Here we go!"
    elsif game.game_is_over(game.board)
      response = game_over_message(game)
    else
      response = responses[rand(0..7)]
    end
    response
  end



  # -----------------------------------------------------------------------------
  # These three methods return computer move based on difficulty level of game
  # -----------------------------------------------------------------------------

  # On easy mode: computer always takes a random open spot
  # No strategy is employed
  def make_easy_move(game)
    board = game.board
    spaces = board.available_spaces()
    max = spaces.length
    spot = spaces[rand(0...max)].to_i
    board[spot] = self.symbol
    board.save
    return spot
  end

  # On medium mode: computer always starts with middle spot if open.
  # If middle spot not available get_best_medium_move() is called.
  # get_best_medium_move() first looks for opportunity to win
    # if no winning possibility, then method looks for opportunity to block an imminent win from
    # opposite player, if opposing player doesn't have opportunity to win on next turn, method
    # chooses a random open spot
  def make_medium_move(game)
    board = game.board
    if board[4] == "4"
      spot = 4
      board[spot] = self.symbol
    else
      spot = get_best_medium_move(game)
      board[spot] = self.symbol
    end
    board.save
    return spot
  end

  # On hard mode: computer move is governed by minimax algorithm (see below)
  def make_hard_move(game)
    board = game.board
    if board.available_spaces.length >= 8
      @spot = expedite_first_minimax_spot(board)
    else
      minimax(game, board, self.symbol, depth = 0, self.symbol)
    end
    board[@spot] = self.symbol
    board.save
    return @spot.to_i
  end
  # -----------------------------------------------------------------------------
  # -----------------------------------------------------------------------------


  # controls what is sent to frontend with each request
  def as_json
    {
      id: id,
      game_id: game_id,
      name: name,
      symbol: symbol,
      player_type: "Computer"
    }
  end

  private

    # Array of human-like responses for mid-gameplay, used in selected_response()
    def responses
      [
        "Hmm, nice move. My turn...",
        "Oooh you're good. Let's see...",
        "You're playing to win, huh? Not on my watch...",
        "Interesting... Let's see how you deal with this...",
        "I see you're actually trying. Well you're not the only one...",
        "Ok, I see what you did there. Now check this out...",
        "Alright, alright. My turn!",
        "Boom. Choosing spots like a boss. But I'm playing like a CEO :P"
      ]
    end

    # game_over_message() notes:
    # 
    # Human-like responses used in selected_response() for when game is over
    # Response calls winner (or loser) out by name, or declares a tie
    # 'Computer' always displays positive sportsmanship
    # 'Computer' always wants to play again!
    def game_over_message(game)
      if game.winner(game.board) == game.player1
        return "Great job #{game.player1.name}! Let's play again!"
      elsif game.winner(game.board) == game.player2
        return "I win! Nice try #{game.player1.name}! Let's play again!"
      else
        return "It was a tie! Let's play again!"
      end
    end

    # Called by make_medium_move()
    def get_best_medium_move(game)
      board = game.board
      spaces = board.available_spaces
      # Evaluate ALL possibilities -- IF computer can win, take/return the spot
      spaces.each do |available_space|
        board[available_space.to_i] = self.symbol
        if game.winner(board) == self
          spot = available_space.to_i
          board[available_space.to_i] = available_space
          return spot
        else
          board[available_space.to_i] = available_space
        end
      end
      # Evaluate ALL possibilities -- IF opposite player could win, block/return the spot
      spaces.each do |available_space|
        board[available_space.to_i] = opposite_player(self.symbol)
        if game.winner(board) && game.winner(board).symbol == opposite_player(self.symbol)
          spot = available_space.to_i
          board[available_space.to_i] = available_space
          return spot
        else
          board[available_space.to_i] = available_space
        end
      end
      # Otherwise take/return random spot
      max = spaces.length
      spot = spaces[rand(0...max)].to_i
      return spot
    end


    # Since minimax algrithm takes time to process, computer move on empty
    # board and second move of game have been hard-coded to speed up gameplay
    def expedite_first_minimax_spot(board)
      if board.available_spaces.length == 9
        return board.corners[rand(0..3)]
      elsif board.available_spaces.length == 8
        if board.center_taken
          return board.corners[rand(0..3)]
        elsif board.corner_taken
          return 4
        elsif board.edge_taken
          return board.edge_first_minimax_moves[board.first_move]
        end
      end
    end

    # minimax() notes:
    # 
    # Called by make_hard_move():
    # Recursively runs through every single possible move and counter-move etc. until game
    # ends to assign every possible move a score and eventually determine the best move
    # possible for the computer to make - sets @spot to move with best score
    # 'Best score' is a relative term: highest score if win for current player, lowest
    # score if win for opposite player
    def minimax(game, board, player_symbol, depth, current_player_symbol)
      if game.game_is_over(board)
        return get_score(board, depth, game, current_player_symbol)
      end

      depth += 1
      scores = []
      moves = []
      board.available_spaces.each do |space|
        new_board = board.dup
        new_board[space.to_i] = player_symbol
        scores << minimax(game, new_board, opposite_player(player_symbol), depth, current_player_symbol) # if game over, store score in array to eventually pass up best score
        moves << space # store move that correlates to stored score above
      end
      
      if current_player_symbol == player_symbol
        # Max calculation
        max_score_index = scores.each_with_index.max[1]
        @spot = moves[max_score_index]
        return scores[max_score_index]
      else
        # Min calculation
        min_score_index = scores.each_with_index.min[1]
        @spot = moves[min_score_index]
        return scores[min_score_index]
      end
    end


    # Used in minimax to determine 'score' (see below)
    def opposite_player(symbol)
      symbol == "X" ? "O" : "X"
    end


    # get_score() notes:
    # 
    # Used in minimax to calculate score of end of game
    # Depth: how many moves have been made between current game-state and potential end-state (win or tie)
    # If potential win for current player: 10 pts minus depth
    # If potential win for opposite player: depth minus 10 pts
    # If potential tie: 0 pts
    def get_score(board, depth, game, current_player_symbol)
      winner = game.winner(board)
      if winner && winner.symbol == current_player_symbol
        return 10 - depth
      elsif winner && winner.symbol == opposite_player(current_player_symbol)
        return depth - 10
      else
        return 0
      end
    end

end