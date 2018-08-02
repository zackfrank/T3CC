class Board < ApplicationRecord

  def available_spaces(board)
    unless game_is_over(board) || tie(board)
      board.select {|s| s != "X" && s != "O" }
    end
  end

end
