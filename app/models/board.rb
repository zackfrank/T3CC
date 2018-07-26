class Board < ApplicationRecord

  def spots
    {
      0 => "top-left corner",
      1 => "top-middle",
      2 => "top-right corner",
      3 => "middle-left",
      4 => "center",
      5 => "middle-right",
      6 => "bottom-left corner",
      7 => "bottom-middle",
      8 => "bottom-right corner",
    }
  end

  def available_spaces(board)
    unless game_is_over(board) || tie(board)
      board.select {|s| s != "X" && s != "O" }
    end
  end

  def as_json
    {
      id: id,
      spaces: spaces
    }
  end

end
