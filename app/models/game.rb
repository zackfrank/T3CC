class Game < ApplicationRecord
 
  def player_setup(game_type)
    if game_type == 1
      self.player_1 = Human.new
      self.player_2 = Human.new
    elsif game_type == 2
      self.player_1 = Human.new
      self.player_2 = Computer.new
    elsif game_type == 3
      self.player_1 = Computer.new
      self.player_2 = Computer.new
    end
  end

  def set_difficulty_level(level)
    if level == 1
      self.difficulty_level = "Easy"
    elsif level == 2
      self.difficulty_level = "Medium"
    elsif level == 3
      self.difficulty_level = "Hard"
    end
  end

  def name_players(names)
    self.player_1.name = names[0]
    self.player_2.name = names[1]
  end

  def set_symbols(who_is_x)
    if who_is_x == player_1
      self.player_1.symbol = "X"
      self.player_2.symbol = "O"
    else
      self.player_1.symbol = "O"
      self.player_2.symbol = "X"
    end
  end

  def get_score(board, depth)
    winner(board)
    if @winner == @current_player
      return 10 - depth
    elsif @winner == opposite_player(@current_player)
      return depth - 10
    else
      return 0
    end
  end

  def minimax(board, player, depth)
    if game_is_over(board) || tie(board)
      return get_score(board, depth)
    end
    depth += 1
    scores = []
    moves = []
    available_spaces(board).each do |space|
      new_board = board.dup # temporary representation of current board
      new_board[space.to_i] = player.make_move # make potential move on temp board 
      scores << minimax(new_board, opposite_player(player), depth) # store potential state of board in array
      moves << space # store possible move (available space) in array
    end
    
    if @difficulty_level == "Hard"
      if @current_player == player
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
    else
      if @current_player == player
        # This is the min calculation
        min_score_index = scores.each_with_index.min[1]
        @choice = moves[min_score_index]
        return scores[min_score_index]
      else
        # This is the max calculation
        max_score_index = scores.each_with_index.max[1]
        @choice = moves[max_score_index]
        return scores[max_score_index]
      end
    end
  end

  def game_is_over(b) #switch to someone_wins or something so game_is_over can be used to combine this and tie
    [b[0], b[1], b[2]].uniq.length == 1 ||
    [b[3], b[4], b[5]].uniq.length == 1 ||
    [b[6], b[7], b[8]].uniq.length == 1 ||
    [b[0], b[3], b[6]].uniq.length == 1 ||
    [b[1], b[4], b[7]].uniq.length == 1 ||
    [b[2], b[5], b[8]].uniq.length == 1 ||
    [b[0], b[4], b[8]].uniq.length == 1 ||
    [b[2], b[4], b[6]].uniq.length == 1
  end

  def tie(b)
    b.all? { |s| s == "X" || s == "O" }
  end

  def winner(b)
    winning_possibilities = [
      [b[0], b[1], b[2]],
      [b[3], b[4], b[5]],
      [b[6], b[7], b[8]],
      [b[0], b[3], b[6]],
      [b[1], b[4], b[7]],
      [b[2], b[5], b[8]],
      [b[0], b[4], b[8]],
      [b[2], b[4], b[6]]
    ]
    if winning_possibilities.detect {|possible_win| possible_win.all? @player2.make_move }
      @winner = @player2
    elsif winning_possibilities.detect {|possible_win| possible_win.all? @player1.make_move }
      @winner = @player1
    else
      @winner = 'Tie'
    end
  end

  def winning_message
    if @winner == @player1
      return "#{@names[@player1]} wins! Great job #{@names[@player1]}! Play again!"
    elsif @winner == @player2
      return "#{@names[@player2]} wins! Nice try #{@names[@player1]}! Play again!"
    else
      return "It was a tie! Play again!"
    end
  end

end
