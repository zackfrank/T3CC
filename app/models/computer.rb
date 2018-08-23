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
    spot = nil
    board = game.board
    board.available_spaces.each do |available_space|
      board[available_space.to_i] = self.symbol
      if game.winner(board) == self
        spot = available_space.to_i
        board[available_space.to_i] = available_space.to_s
        return spot
      else
        board[available_space.to_i] = game.opposite_player(self).symbol
        if game.winner(board) == game.opposite_player(self)
          spot = available_space.to_i
          board[available_space.to_i] = available_space.to_s
          return spot
        else
          board[available_space.to_i] = available_space.to_s
        end
      end
    end
    if !spot
      spaces = game.board.available_spaces()
      max = spaces.length
      spot = spaces[rand(0...max)].to_i
      return spot
    end
  end

  def hard_eval_board(game)
    board = game.board
    if board.available_spaces.length >= 8
      @choice = board.expedite_first_minimax_spot
    else
      minimax(game, board, self, depth = 0, self)
    end
    board[@choice] = self.symbol
    board.save
  end

  def get_score(board, depth, game, current_player)
    winner = game.winner(board)
    if winner == current_player
      return 10 - depth
    elsif winner == game.opposite_player(current_player)
      return depth - 10
    else
      return 0
    end
  end

  def minimax(game, board, player, depth, current_player)
    if game.game_is_over(board)
      return get_score(board, depth, game, current_player)
    end

    depth += 1
    scores = []
    moves = []
    board.available_spaces.each do |space|
      new_board = board.dup # temporary representation of current board
      new_board[space.to_i] = player.symbol # make potential move on temp board 
      scores << minimax(game, new_board, game.opposite_player(player), depth, current_player) # if game over, store score in array to eventually pass up best score
      moves << space # store move that correlates to stored score above
    end
    
    if current_player == player
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

  def computer_move_description(spot)
    if !game_is_over(@board) && !tie(@board)
      puts "#{self.name}: I took the #{spots[spot]} spot."
    end
  end

end
