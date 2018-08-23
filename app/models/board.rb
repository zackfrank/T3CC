class Board < ApplicationRecord

  def setup
    index = 0
    9.times do
      self[index] = index
      index += 1
    end
  end

  def spaces_array #array of spaces
    spaces_array = []
    index = 0
    9.times do
      spaces_array << self[index]
      index += 1
    end
    return spaces_array
  end

  def available_spaces()
    # unless game.game_is_over(board)
    return spaces_array.select {|space| space != "X" && space != "O" }
    # end
  end

  def corners()
    [self[0], self[2], self[6], self[8]]
  end

  def edges()
    [self[1], self[3], self[5], self[7]]
  end

  def center_taken()
    self[4] == "X" || self[4] == "O"
  end

  def corner_taken()
    corners.any? {|corner| corner == "X" || corner == "O"}
  end

  def edge_taken()
    edges.any? {|edge| edge == "X" || edge == "O"}
  end

  def edge_first_minimax_moves()
    {1 => 7, 5 => 8, 3 => 6,6 => 8}
  end

  def first_move()
    spaces_array.detect {|spot| spot == "X" || spot == "O" }
  end

  def expedite_first_minimax_spot
    if available_spaces.length == 9
      return 8
    elsif available_spaces.length == 8
      if board.center_taken
        return corners[rand(0..3)].to_i
      elsif board.corner_taken
        return 4
      elsif board.edge_taken
        return edge_first_minimax_moves[first_move]
      end
    else 
      return nil
    end
  end

end
