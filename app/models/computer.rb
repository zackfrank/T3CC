class Computer < ApplicationRecord
 
  def initialize
    @com
  end

  def set_symbol(symbol)
    @com = symbol
  end

  def make_move
    @com
  end

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

  def medium_eval_board
    if @difficulty_level == "Medium"
      spot = nil
      until spot
        if @board[4] == "4"
          spot = 4
          @board[spot] = @current_player.make_move # if available, comp takes middle spot
        else
          spot = get_best_move(@board, @current_player)
          if @board[spot] != "X" && @board[spot] != "O"
            @board[spot] = @current_player.make_move
          else
            spot = nil
          end
        end
      end
    end
  end

  def hard_eval_board
    spot = get_best_move(@board, @current_player)
    @board[spot] = @current_player.make_move
    computer_move_description(spot)
  end

  def get_best_move(board, player, depth = 0)
    if @difficulty_level == "Medium"
      best_move = nil
      available_spaces(board).each do |as|
        board[as.to_i] = @current_player.make_move
        if game_is_over(board)
          best_move = as.to_i
          board[as.to_i] = as
          return best_move
        else
          board[as.to_i] = opposite_player(@current_player).make_move
          if game_is_over(board)
            best_move = as.to_i
            board[as.to_i] = as
            return best_move
          else
            board[as.to_i] = as
          end
        end
      end
      if best_move
        return best_move
      else
        n = rand(0..available_spaces(board).count)
        return available_spaces(board)[n].to_i
      end
    else
      minimax(board, player, depth)
      return @choice.to_i
    end
  end

  def computer_move_description(spot)
    if !game_is_over(@board) && !tie(@board)
      puts "#{@names[@current_player]}: I took the #{spots[spot]} spot.\n\n"
    end
  end

end
