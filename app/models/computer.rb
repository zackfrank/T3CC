class Computer < ApplicationRecord
  belongs_to :game
  validates :game, presence: false
 
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

  def selected_response(game)
    if game.board.available_spaces.length == 8
      # available spaces is 8 rather than 9 because this method will always be called
      # after the first move is made, in the as_json when sending data back to frontend
      response = "Here we go!"
    elsif game.game_is_over(game.board)
      response = game_over_message(game)
    else
      response = responses[rand(0..7)]
    end
    response
  end

  def game_over_message(game)
    if game.winner(game.board) == game.player1
      return "Great job #{game.player1.name}! Let's play again!"
    elsif game.winner(game.board) == game.player2
      return "I win! Nice try #{game.player1.name}! Let's play again!"
    else
      return "It was a tie! Let's play again!"
    end
  end

  def easy_eval_board(game)
    board = game.board
    spaces = board.available_spaces()
    max = spaces.length
    spot = spaces[rand(0...max)].to_i
    board[spot] = self.symbol
    board.save
  end

  def medium_eval_board(game)
    # spot = nil
    board = game.board
    if board[4] == "4"
      spot = 4
      board[spot] = self.symbol # if available, comp takes middle spot
    else
      spot = get_best_medium_move(game)
      board[spot] = self.symbol
    end
    board.save
  end

  def get_best_medium_move(game)
    board = game.board
    spaces = board.available_spaces
    # Evaluate ALL possibilities -- IF computer can win, take the spot
    spaces.each do |available_space|
      board[available_space.to_i] = self.symbol
      if game.winner(board) == self
        spot = available_space.to_i
        board[available_space.to_i] = available_space.to_s
        return spot
      else
        board[available_space.to_i] = available_space.to_s
      end
    end
    # Evaluate ALL possibilities -- IF opposite player could win, block the spot
    spaces.each do |available_space|
      board[available_space.to_i] = opposite_player(self.symbol) # changed from game.opposite_player(self).symbol
      if game.winner(board) == game.opposite_player(self)
        spot = available_space.to_i
        board[available_space.to_i] = available_space.to_s
        return spot
      else
        board[available_space.to_i] = available_space.to_s
      end
    end
    # Otherwise take random spot
    max = spaces.length
    spot = spaces[rand(0...max)].to_i
    return spot
  end

  def hard_eval_board(game)
    board = game.board
    if board.available_spaces.length >= 8
      @choice = expedite_first_minimax_spot(board)
    else
      minimax(game, board, self.symbol, depth = 0, self.symbol)
    end
    board[@choice] = self.symbol
    board.save
  end

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
    else 
      return nil
    end
  end

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

  def opposite_player(symbol)
    symbol == "X" ? "O" : "X"
  end

  def minimax(game, board, player_symbol, depth, current_player_symbol)
    if game.game_is_over(board)
      return get_score(board, depth, game, current_player_symbol)
    end

    depth += 1
    scores = []
    moves = []
    board.available_spaces.each do |space|
      new_board = board.dup # temporary representation of current board
      new_board[space.to_i] = player_symbol # make potential move on temp board 
      scores << minimax(game, new_board, opposite_player(player_symbol), depth, current_player_symbol) # if game over, store score in array to eventually pass up best score
      moves << space # store move that correlates to stored score above
    end
    
    if current_player_symbol == player_symbol
      # This is the max calculation
      max_score_index = scores.each_with_index.max[1]
      @choice = moves[max_score_index]
      return scores[max_score_index]
    else
      # This is the min calculation
      min_score_index = scores.each_with_index.min[1]
      @choice = moves[min_score_index]
      return scores[min_score_index]
    end
  end

  # not used yet
  # def computer_move_description(_spot)
  #   "I took the (insert spot description from hash) spot."
  # end

  def as_json
    {
      id: id,
      game_id: game_id,
      name: name,
      symbol: symbol,
      player_type: "Computer"
    }
  end

end
