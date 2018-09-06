require 'rails_helper'

RSpec.describe Board, type: :model do
  
# ----------------------
# TEST METHOD - setup()
# ----------------------

  it "adds index (or spot number) in string format to each spot on the board 0-8" do
    board = Board.new
    board.setup
    expect(board[0]).to eq('0')
    expect(board[1]).to eq('1')
    expect(board[2]).to eq('2')
    expect(board[3]).to eq('3')
    expect(board[4]).to eq('4')
    expect(board[5]).to eq('5')
    expect(board[6]).to eq('6')
    expect(board[7]).to eq('7')
    expect(board[8]).to eq('8')
  end

# -----------------------------
# TEST METHOD - spaces_array()
# -----------------------------

  it "creates an array made up of the spaces that make up the board" do
    board = Board.new
    board.setup
    board = board.spaces_array.map { |spot| spot + " spot" } # test array method (#map) to ensure #spaces_array creates array
    expect(board[0]).to eq('0 spot')
    expect(board[1]).to eq('1 spot')
    expect(board[2]).to eq('2 spot')
    expect(board[3]).to eq('3 spot')
    expect(board[4]).to eq('4 spot')
    expect(board[5]).to eq('5 spot')
    expect(board[6]).to eq('6 spot')
    expect(board[7]).to eq('7 spot')
    expect(board[8]).to eq('8 spot')
  end

# --------------------------------
# TEST METHOD - available_spaces()
# --------------------------------

  it "identifies available spaces on the board" do
    board = Board.new
    board.setup
    board[0] = "X"
    board[1] = "O"
    board[2] = "X"
    board[4] = "O"
    board[5] = "X"
    board[8] = "O"
    expect(board.available_spaces).to eq(["3", "6", "7"])
  end

# ------------------------
# TEST METHOD - corners()
# ------------------------

  it "creates array of all four corners" do
    board = Board.new
    board.setup
    board[0] = "X"
    board[1] = "O"
    board[2] = "X"
    board[3] = "O"
    board[4] = "O"
    board[5] = "O"
    board[6] = "X"
    board[7] = "O"
    board[8] = "X"
    expect(board.corners).to eq(["X", "X", "X", "X"])
  end

  it "creates array of all four corners" do
    board = Board.new
    board.setup
    board[0] = "X"
    board[1] = "O"
    board[2] = "O"
    board[3] = "O"
    board[4] = "O"
    board[5] = "O"
    board[6] = "X"
    board[7] = "O"
    board[8] = "O"
    expect(board.corners).to eq(["X", "O", "X", "O"])
  end

  it "creates array of all four corners" do
    board = Board.new
    board.setup
    board[0] = "O"
    board[1] = "O"
    board[2] = "X"
    board[3] = "O"
    board[4] = "O"
    board[5] = "O"
    board[6] = "X"
    board[7] = "O"
    board[8] = "O"
    expect(board.corners).to eq(["O", "X", "X", "O"])
  end

  it "creates array of all four corners" do
    board = Board.new
    board.setup
    board[0] = "G"
    board[1] = "O"
    board[2] = "A"
    board[3] = "O"
    board[4] = "O"
    board[5] = "O"
    board[6] = "M"
    board[7] = "O"
    board[8] = "E"
    expect(board.corners).to eq(["G", "A", "M", "E"])
  end

# ------------------------
# TEST METHOD - edges()
# ------------------------

  it "creates array of all four edges" do
    board = Board.new
    board.setup
    board[0] = "X"
    board[1] = "O"
    board[2] = "X"
    board[3] = "O"
    board[4] = "O"
    board[5] = "O"
    board[6] = "X"
    board[7] = "O"
    board[8] = "X"
    expect(board.edges).to eq(["O", "O", "O", "O"])
  end

  it "creates array of all four edges" do
    board = Board.new
    board.setup
    board[0] = "X"
    board[1] = "X"
    board[2] = "O"
    board[3] = "O"
    board[4] = "O"
    board[5] = "X"
    board[6] = "X"
    board[7] = "O"
    board[8] = "O"
    expect(board.edges).to eq(["X", "O", "X", "O"])
  end

  it "creates array of all four edges" do
    board = Board.new
    board.setup
    board[0] = "O"
    board[1] = "O"
    board[2] = "X"
    board[3] = "X"
    board[4] = "O"
    board[5] = "X"
    board[6] = "X"
    board[7] = "O"
    board[8] = "O"
    expect(board.edges).to eq(["O", "X", "X", "O"])
  end

  it "creates array of all four edges" do
    board = Board.new
    board.setup
    board[0] = "O"
    board[1] = "G"
    board[2] = "X"
    board[3] = "A"
    board[4] = "O"
    board[5] = "M"
    board[6] = "X"
    board[7] = "E"
    board[8] = "X"
    expect(board.edges).to eq(["G", "A", "M", "E"])
  end

# ------------------------
# TEST METHOD - center_taken()
# ------------------------

  it "returns false since center is not taken'" do
    board = Board.new
    board.setup
    board[0] = "X"
    board[1] = "O"
    board[2] = "X"
    board[3] = "O"
    board[5] = "O"
    board[6] = "X"
    board[7] = "O"
    board[8] = "X"
    expect(board.center_taken).to eq(false)
  end

  it "returns true since center is taken by 'O'" do
    board = Board.new
    board.setup
    board[0] = "X"
    board[1] = "X"
    board[2] = "O"
    board[3] = "O"
    board[4] = "O"
    board[5] = "X"
    board[6] = "X"
    board[7] = "O"
    board[8] = "O"
    expect(board.center_taken).to eq(true)
  end

  it "returns true since center is taken by 'X'" do
    board = Board.new
    board.setup
    board[0] = "X"
    board[1] = "X"
    board[2] = "O"
    board[3] = "O"
    board[4] = "X"
    board[5] = "X"
    board[6] = "X"
    board[7] = "O"
    board[8] = "O"
    expect(board.center_taken).to eq(true)
  end

# ----------------------------
# TEST METHOD - corner_taken()
#
# uses 'corners()'
# ----------------------------

  it "returns true since top left corner is taken by 'X'" do
    board = Board.new
    board.setup
    board[0] = "X"
    board[1] = "O"
    board[3] = "O"
    board[5] = "O"
    board[7] = "O"
    expect(board.corner_taken).to eq(true)
  end

  it "returns true since top left corner is taken by 'O'" do
    board = Board.new
    board.setup
    board[0] = "O"
    board[1] = "O"
    board[3] = "O"
    board[5] = "O"
    board[7] = "O"
    expect(board.corner_taken).to eq(true)
  end

  it "returns true since top right corner is taken by 'X'" do
    board = Board.new
    board.setup
    board[1] = "X"
    board[2] = "X"
    board[3] = "O"
    board[4] = "O"
    board[5] = "X"
    board[7] = "O"
    expect(board.corner_taken).to eq(true)
  end

  it "returns true since top right corner is taken by 'O'" do
    board = Board.new
    board.setup
    board[1] = "X"
    board[2] = "O"
    board[3] = "O"
    board[4] = "O"
    board[5] = "X"
    board[7] = "O"
    expect(board.corner_taken).to eq(true)
  end

  it "returns true since bottom left corner is taken by 'X'" do
    board = Board.new
    board.setup
    board[1] = "X"
    board[3] = "O"
    board[4] = "X"
    board[5] = "X"
    board[6] = "X"
    board[7] = "O"
    expect(board.corner_taken).to eq(true)
  end

  it "returns true since bottom left corner is taken by 'O'" do
    board = Board.new
    board.setup
    board[1] = "X"
    board[3] = "O"
    board[4] = "X"
    board[5] = "X"
    board[6] = "O"
    board[7] = "O"
    expect(board.corner_taken).to eq(true)
  end

  it "returns true since bottom right corner is taken by 'X'" do
    board = Board.new
    board.setup
    board[1] = "X"
    board[3] = "O"
    board[4] = "X"
    board[5] = "X"
    board[7] = "O"
    board[8] = "X"
    expect(board.corner_taken).to eq(true)
  end

  it "returns true since bottom right corner is taken by 'O'" do
    board = Board.new
    board.setup
    board[1] = "X"
    board[3] = "O"
    board[4] = "X"
    board[5] = "X"
    board[7] = "O"
    board[8] = "O"
    expect(board.corner_taken).to eq(true)
  end

  it "returns false since no corners are taken" do
    board = Board.new
    board.setup
    board[1] = "X"
    board[3] = "O"
    board[4] = "X"
    board[5] = "X"
    board[7] = "O"
    expect(board.corner_taken).to eq(false)
  end

# ----------------------------
# TEST METHOD - edge_taken()
#
# uses 'edges()'
# ----------------------------

  it "returns true since top edge is taken by 'X'" do
    board = Board.new
    board.setup
    board[0] = "X"
    board[1] = "X"
    board[2] = "X"
    board[4] = "O"
    board[6] = "O"
    board[8] = "O"
    expect(board.edge_taken).to eq(true)
  end

  it "returns true since top edge is taken by 'O'" do
    board = Board.new
    board.setup
    board[0] = "X"
    board[1] = "O"
    board[2] = "X"
    board[4] = "O"
    board[6] = "O"
    board[8] = "O"
    expect(board.edge_taken).to eq(true)
  end

  it "returns true since left edge is taken by 'X'" do
    board = Board.new
    board.setup
    board[0] = "X"
    board[2] = "X"
    board[3] = "X"
    board[4] = "O"
    board[6] = "X"
    board[8] = "O"
    expect(board.edge_taken).to eq(true)
  end

  it "returns true since left edge is taken by 'O'" do
    board = Board.new
    board.setup
    board[0] = "X"
    board[2] = "O"
    board[3] = "O"
    board[4] = "O"
    board[6] = "X"
    board[8] = "O"
    expect(board.edge_taken).to eq(true)
  end

  it "returns true since right edge is taken by 'X'" do
    board = Board.new
    board.setup
    board[0] = "X"
    board[2] = "O"
    board[4] = "X"
    board[5] = "X"
    board[6] = "X"
    board[8] = "O"
    expect(board.edge_taken).to eq(true)
  end

  it "returns true since right edge is taken by 'O'" do
    board = Board.new
    board.setup
    board[0] = "X"
    board[2] = "O"
    board[4] = "X"
    board[5] = "O"
    board[6] = "O"
    board[8] = "O"
    expect(board.edge_taken).to eq(true)
  end

  it "returns true since bottom edge is taken by 'X'" do
    board = Board.new
    board.setup
    board[0] = "X"
    board[2] = "O"
    board[4] = "X"
    board[6] = "O"
    board[7] = "X"
    board[8] = "X"
    expect(board.edge_taken).to eq(true)
  end

  it "returns true since bottom edge is taken by 'O'" do
    board = Board.new
    board.setup
    board[0] = "X"
    board[2] = "O"
    board[4] = "X"
    board[6] = "X"
    board[7] = "O"
    board[8] = "O"
    expect(board.edge_taken).to eq(true)
  end

  it "returns false since no edges are taken" do
    board = Board.new
    board.setup
    board[0] = "X"
    board[2] = "O"
    board[4] = "X"
    board[6] = "X"
    board[2] = "O"
    expect(board.edge_taken).to eq(false)
  end

# ----------------------------------------
# TEST METHOD - edge_first_minimax_moves()
# ----------------------------------------

  it "returns 7 when given 1" do
    board = Board.new
    expect(board.edge_first_minimax_moves[1]).to eq(7)
  end

  it "returns 8 when given 5" do
    board = Board.new
    expect(board.edge_first_minimax_moves[5]).to eq(8)
  end

  it "returns 6 when given 3" do
    board = Board.new
    expect(board.edge_first_minimax_moves[3]).to eq(6)
  end

  it "returns 8 when given 7" do
    board = Board.new
    expect(board.edge_first_minimax_moves[7]).to eq(8)
  end

# ----------------------------------------
# TEST METHOD - first_move()
# ----------------------------------------

  it "returns 0 when 'O' is in spot 0" do
    board = Board.new
    board[0] = "O"
    expect(board.first_move).to eq(0)
  end

  it "returns 1 when 'X' is in spot 1" do
    board = Board.new
    board[1] = "X"
    expect(board.first_move).to eq(1)
  end

  it "returns 2 when 'O' is in spot 2" do
    board = Board.new
    board[2] = "O"
    expect(board.first_move).to eq(2)
  end

  it "returns 3 when 'X' is in spot 3" do
    board = Board.new
    board[3] = "X"
    expect(board.first_move).to eq(3)
  end

  it "returns 4 when 'O' is in spot 4" do
    board = Board.new
    board[4] = "O"
    expect(board.first_move).to eq(4)
  end

  it "returns 5 when 'X' is in spot 5" do
    board = Board.new
    board[5] = "X"
    expect(board.first_move).to eq(5)
  end

  it "returns 6 when 'O' is in spot 6" do
    board = Board.new
    board[6] = "O"
    expect(board.first_move).to eq(6)
  end

  it "returns 7 when 'X' is in spot 7" do
    board = Board.new
    board[7] = "X"
    expect(board.first_move).to eq(7)
  end

  it "returns 8 when 'X' is in spot 8" do
    board = Board.new
    board[8] = "X"
    expect(board.first_move).to eq(8)
  end

  it "returns nil when board is empty" do
    board = Board.new
    expect(board.first_move).to eq(nil)
  end

end