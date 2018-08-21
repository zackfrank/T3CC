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

end
