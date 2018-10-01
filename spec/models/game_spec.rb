require 'rails_helper'

RSpec.describe Game, type: :model do

# ---------------------------------------------------------------------------------------------------------
# TEST METHOD -- setup(params)
# Saves game_type, board_id, and difficulty_level (for games with AI) to database
# 'game_type' options are 'hvh' (human vs. human), 'hvc' (human vs. computer), or 'cvc' (computer vs. computer)
# 'difficulty_level' options are: 'Easy', 'Medium', 'Hard'
# ---------------------------------------------------------------------------------------------------------

  it "creates new 'human vs human' game" do
    game = Game.new
    player1 = Human.create
    player1 = {
        id: player1.id,
        symbol: "X",
        player_type: "Human"
    }
    player2 = Human.create
    player2 = {
        id: player2.id,
        symbol: "O",
        player_type: "Human"
    }
    params = {
      game_type: "hvh",
      board_id: 89,
      player1: player1,
      player2: player2,
      names: ["Alex", "Brian"]
    }
    game.setup(params)
    expect(game.game_type).to eq("hvh")
    expect(game.board_id).to eq(89)
  end

  it "creates new 'human vs computer' game" do
    game = Game.new
    player1 = Human.create
    player1 = {
        id: player1.id,
        symbol: "X",
        player_type: "Human"
    }
    player2 = Computer.create
    player2 = {
        id: player2.id,
        symbol: "O",
        player_type: "Computer"
    }
    params = {
      game_type: "hvc",
      level: "Easy",
      board_id: 108,
      player1: player1,
      player2: player2,
      names: ["Charlie", "Computer"]
    }
    game.setup(params)
    expect(game.game_type).to eq("hvc")
    expect(game.difficulty_level).to eq("Easy")
    expect(game.board_id).to eq(108)
  end

  it "creates new 'computer vs computer' game" do
    game = Game.new
    player1 = Computer.create
    player1 = {
        id: player1.id,
        symbol: "X",
        player_type: "Computer"
    }
    player2 = Computer.create
    player2 = {
        id: player2.id,
        symbol: "O",
        player_type: "Computer"
    }
    params = {
      game_type: "cvc",
      level: "Hard",
      board_id: 47,
      player1: player1,
      player2: player2,
      names: ["Computer 1", "Computer 2"]
    }
    game.setup(params)
    expect(game.game_type).to eq("cvc")
    expect(game.difficulty_level).to eq("Hard")
    expect(game.board_id).to eq(47)
  end

# --------------------------------------------------------------------------------------------------------
# TEST METHODS -- player_setup(player1, player2, names, who_is_x) // player1 // player2
# 'player_setup()' saves player symbols (X and O) and player names to database
# Also sets game id for each player in db, and player ids in games table
#
# Since a player could be Computer or Human, players are retrieved based on game type and then matching id
# ie - player1 will always be human in hvh or hvc, only computer in cvc
# ie - player2 will always be computer in hvc or cvc, only human in hvh
# thus - in hvc player1_id is matched with Human id, player2_id matched with Computer id
# --------------------------------------------------------------------------------------------------------

  it "sets up player symbols and names for hvh, player1 is 'X'" do
    game = Game.create(game_type: 'hvh')
    player1 = Human.create
    player2 = Human.create
    player1 = {
        id: player1.id,
        symbol: "X",
        player_type: "Human"
    }
    player2 = {
        id: player2.id,
        symbol: "O",
        player_type: "Human"
    }
    game.player_setup(player1, player2, ["Zack", "Brad"])
    expect(game.player1.symbol).to eq("X")
    expect(game.player1.name).to eq("Zack")
    expect(game.player2.symbol).to eq("O")
    expect(game.player2.name).to eq("Brad")
    expect(game.player1.class).to eq(Human)
    expect(game.player2.class).to eq(Human)
  end  

  it "sets up player symbols and names for hvh, player1 is 'O'" do
    game = Game.create(game_type: 'hvh')
    player1 = Human.create
    player2 = Human.create
    player1 = {
        id: player1.id,
        symbol: "O",
        player_type: "Human"
    }
    player2 = {
        id: player2.id,
        symbol: "X",
        player_type: "Human"
    }
    game.player_setup(player1, player2, ["Zack", "Brad"])
    expect(game.player1.symbol).to eq("O")
    expect(game.player1.name).to eq("Zack")
    expect(game.player2.symbol).to eq("X")
    expect(game.player2.name).to eq("Brad")
    expect(game.player1.class).to eq(Human)
    expect(game.player2.class).to eq(Human)
  end

  it "sets up player symbols and names for cvh, player1 is 'X'" do
    game = Game.create(game_type: 'cvh')
    player1 = Human.create
    player2 = Computer.create
    player1 = {
        id: player1.id,
        symbol: "X",
        player_type: "Human"
    }
    player2 = {
        id: player2.id,
        symbol: "O",
        player_type: "Computer"
    }
    game.player_setup(player1, player2, ["Zack", "Brad"])
    expect(game.player1.symbol).to eq("X")
    expect(game.player1.name).to eq("Zack")
    expect(game.player2.symbol).to eq("O")
    expect(game.player2.name).to eq("Brad")
    expect(game.player1.class).to eq(Human)
    expect(game.player2.class).to eq(Computer)
  end

  it "sets up player symbols and names for cvc, player1 is 'O'" do
    game = Game.create(game_type: 'cvc')
    player1 = Computer.create
    player2 = Computer.create
    player1 = {
        id: player1.id,
        symbol: "O",
        player_type: "Computer"
    }
    player2 = {
        id: player2.id,
        symbol: "X",
        player_type: "Computer"
    }
    game.player_setup(player1, player2, ["Donald", "Hillary"])
    expect(game.player1.symbol).to eq("O")
    expect(game.player1.name).to eq("Donald")
    expect(game.player2.symbol).to eq("X")
    expect(game.player2.name).to eq("Hillary")
    expect(game.player1.class).to eq(Computer)
    expect(game.player2.class).to eq(Computer)
  end

# -------------------------------------------------------------------------------------
# TEST METHODS -- switch_player(player) // next_player
# 'switch_player()' used to setup next_player which is sent to frontend
# 'switch_player()' requires previous player as argument and is used in controller
# thus - 'next_player' is set using instance variable @next_player to be used in as_json
# -------------------------------------------------------------------------------------

  it "switches from player1 to player2" do
    game = Game.create
    player1 = Human.create(game_id: game.id)
    player2 = Computer.create(game_id: game.id)
    game.player1_id = player1.id
    game.player2_id = player2.id
    game.save
    expect(game.switch_player(player1)).to eq(player2)
  end

  it "switches from player2 to player1" do
    game = Game.create
    player1 = Human.create(game_id: game.id)
    player2 = Computer.create(game_id: game.id)
    game.player1_id = player1.id
    game.player2_id = player2.id
    game.save
    expect(game.switch_player(player2)).to eq(player1)
  end

  it "returns player2 as the next player" do
    game = Game.create
    player1 = Human.create(game_id: game.id)
    player2 = Computer.create(game_id: game.id)
    game.player1_id = player1.id
    game.player2_id = player2.id
    game.save
    game.switch_player(player1)
    expect(game.next_player).to eq(player2)
  end

  it "returns player1 as the next player" do
    game = Game.create
    player1 = Human.create(game_id: game.id)
    player2 = Computer.create(game_id: game.id)
    game.player1_id = player1.id
    game.player2_id = player2.id
    game.save
    game.switch_player(player2)
    expect(game.next_player).to eq(player1)
  end

# ---------------------------------------------------------------------------
# TEST METHOD -- make_human_move(player, space)
# Sets appropriate space on board to current human player symbol, saves to db
# ---------------------------------------------------------------------------

  it "sets specified space (4) on board to human player symbol ('X')" do
    board = Board.create
    game = Game.create(board_id: board.id)
    player1 = Human.create(game_id: game.id, symbol: "X")
    game.player1_id = player1.id
    game.save
    game.make_human_move(player1, 4)
    expect(game.board[4]).to eq("X")
  end

  it "sets specified space (8) on board to computer player symbol ('O')" do
    board = Board.create
    game = Game.create(board_id: board.id)
    player2 = Computer.create(game_id: game.id, symbol: "O")
    game.player2_id = player2.id
    game.save
    game.make_human_move(player2, 8)
    expect(game.board[8]).to eq("O")
  end

# -------------------------------------------------------------------------------------------------------
# TEST METHODS -- make_computer_move(player) // Computer#easy_eval_board(game)
# Uses 'Computer#easy_eval_board(game)' to select completely random open spot for computer move
# Sets space chosen from 'easy_eval_board' to current computer player symbol on Boards table, saves to db
# -------------------------------------------------------------------------------------------------------

  it "makes computer move on Easy level" do
    board = Board.create
    game = Game.create(board_id: board.id, difficulty_level: "Easy")
    player2 = Computer.create(game_id: game.id, symbol: "O")
    game.player2_id = player2.id
    game.save
    game.make_computer_move(player2)
    move = game.board.first_move
    expect(game.board[move]).to eq("O")
  end

  it "makes computer move on Easy level" do
    board = Board.create
    game = Game.create(board_id: board.id, difficulty_level: "Easy")
    player1 = Computer.create(game_id: game.id, symbol: "X")
    game.player1_id = player1.id
    game.save
    game.make_computer_move(player1)
    move = game.board.first_move
    expect(game.board[move]).to eq("X")
  end

# -------------------------------------------------------------------------------------------------------
# TEST -- make_computer_move(player) // Computer#medium_eval_board(game) // Board#setup
# 'Computer#medium_eval_board(game)' takes center spot on first or second move
# Beyond first two moves of game, method first looks to win, otherwise block a win from opposite player, 
# otherwise takes random spot, then records current computer player symbol to spot in Boards table in db
# -------------------------------------------------------------------------------------------------------

  it "makes computer move on Medium level, computer takes 4 on empty board" do
    board = Board.create
    game = Game.create(board_id: board.id, difficulty_level: "Medium", game_type: 'hvc')
    game.board.setup
    player1 = Human.create(game_id: game.id, symbol: "O")
    player2 = Computer.create(game_id: game.id, symbol: "X")
    game.player1_id = player1.id
    game.player2_id = player2.id
    game.save
    game.make_computer_move(player2)
    expect(game.board[4]).to eq("X")
  end

  it "makes computer move on Medium level, computer takes 4 if still available" do
    board = Board.create
    game = Game.create(board_id: board.id, difficulty_level: "Medium", game_type: 'hvc')
    game.board.setup
    player1 = Human.create(game_id: game.id, symbol: "O")
    player2 = Computer.create(game_id: game.id, symbol: "X")
    game.player1_id = player1.id
    game.player2_id = player2.id
    game.save
    game.board[2] = "O"
    game.make_computer_move(player2)
    expect(game.board[4]).to eq("X")
  end

  it "makes random first computer move on Medium level if center is taken" do
    board = Board.create
    game = Game.create(board_id: board.id, difficulty_level: "Medium", game_type: 'hvc')
    game.board.setup
    game.board[4] = "X"
    player1 = Human.create(game_id: game.id, symbol: "X")
    player2 = Computer.create(game_id: game.id, symbol: "O")
    game.player1_id = player1.id
    game.player2_id = player2.id
    game.save
    game.make_computer_move(player2)
    # since computer should take random spot, confirm a spot is taken and only one spot
    expect(game.board.available_spaces.length).to eq(7)
    expect(game.board.spaces_array.any? {|space| space == "O"}).to eq(true)
  end

  it "computer blocks player 1 from winning horizontally on Medium level" do
    board = Board.create
    game = Game.create(board_id: board.id, difficulty_level: "Medium", game_type: 'hvc')
    game.board.setup
    player1 = Human.create(game_id: game.id, symbol: "X")
    player2 = Computer.create(game_id: game.id, symbol: "O")
    game.player1_id = player1.id
    game.player2_id = player2.id
    game.save
    game.board[0] = "X"
    game.board[1] = "X"
    game.board[4] = "O"
    game.make_computer_move(player2)
    expect(game.board[2]).to eq("O")
  end

  it "computer blocks player 1 from winning diagonally on Medium level" do
    board = Board.create
    game = Game.create(board_id: board.id, difficulty_level: "Medium", game_type: 'hvc')
    game.board.setup
    player1 = Human.create(game_id: game.id, symbol: "O")
    player2 = Computer.create(game_id: game.id, symbol: "X")
    game.player1_id = player1.id
    game.player2_id = player2.id
    game.save
    game.board[4] = "O"
    game.board[2] = "O"
    game.board[0] = "X"
    game.make_computer_move(player2)
    expect(game.board[6]).to eq("X")
  end

  it "computer takes diagonal winning spot on Medium level rather than blocking opponent" do
    board = Board.create
    game = Game.create(board_id: board.id, difficulty_level: "Medium", game_type: 'hvc')
    game.board.setup
    player1 = Human.create(game_id: game.id, symbol: "X")
    player2 = Computer.create(game_id: game.id, symbol: "O")
    game.player1_id = player1.id
    game.player2_id = player2.id
    game.save
    game.board[4] = "O"
    game.board[2] = "O"
    game.board[0] = "X"
    game.board[1] = "X"
    game.make_computer_move(player2)
    expect(game.board[6]).to eq("O")
  end

  it "computer takes vertical winning spot on Medium level rather than blocking opponent" do
    board = Board.create
    game = Game.create(board_id: board.id, difficulty_level: "Medium", game_type: 'hvc')
    game.board.setup
    player1 = Human.create(game_id: game.id, symbol: "X")
    player2 = Computer.create(game_id: game.id, symbol: "O")
    game.player1_id = player1.id
    game.player2_id = player2.id
    game.save
    game.board[2] = "O"
    game.board[5] = "O"
    game.board[1] = "X"
    game.board[4] = "X"
    game.make_computer_move(player2)
    expect(game.board[8]).to eq("O")
  end

  it "computer takes last available spot to tie game" do
    board = Board.create
    game = Game.create(board_id: board.id, difficulty_level: "Medium", game_type: 'hvc')
    game.board.setup
    player1 = Human.create(game_id: game.id, symbol: "X")
    player2 = Computer.create(game_id: game.id, symbol: "O")
    game.player1_id = player1.id
    game.player2_id = player2.id
    game.save
    game.board[0] = "O"
    game.board[1] = "O"
    game.board[2] = "X"
    game.board[3] = "X"
    game.board[4] = "X"
    game.board[5] = "O"
    game.board[6] = "O"
    game.board[7] = "X"
    game.make_computer_move(player2)
    expect(game.board[8]).to eq("O")
  end

# -------------------------------------------------------------------------------------------------------
# TEST METHODS -- make_computer_move(player) // Computer#hard_eval_board(game)
# TEST METHODS -- setup(params) // Computer#expedite_first_minimax_spot(board)
# TEST METHODS -- winning_possibilities(board) // someone_wins(board) // tie(board) // game_is_over(board)
# 'Computer#hard_eval_board(game)' uses Minimax algorithm to determine absolute best move
# based on every possible outcome of every possible combination of moves, then returns move that will 
# both prolong the game and lead to Computer win or tie if win is impossible
#
# 'winning_possibilities(board)' - array of rows/colunms/diagonals, used in 'someone_wins(board)' and 'winner(board)'
#
# 'someone_wins(board)' - returns boolean if there is a winner
#
# 'tie(game)' - returns boolean if game ends in tie 
#
# 'game_is_over(board)' - returns boolean if winner or tie 
#
# 'Computer#expedite_first_minimax_spot(board)' used inside of 'Computer#hard_eval_board(game)'
# This is used to cut down on processing time for minimax algorithm - first computer moves are hard-coded
# depending on center, corner, or edge spot taken --- otherwise processing takes far too long
# --------------------------------------------------------------------------------------------------------

# ~~~ Expedited minimax moves (hard-coded) ~~~

  it "makes first computer move on Hard level, computer takes a corner on empty board" do
    board = Board.create
    game = Game.create(board_id: board.id, difficulty_level: "Hard", game_type: 'hvc')
    game.board.setup
    player1 = Human.create(game_id: game.id, symbol: "X")
    player2 = Computer.create(game_id: game.id, symbol: "O")
    game.player1_id = player1.id
    game.player2_id = player2.id
    game.save
    game.make_computer_move(player2)
    expect(game.board.corners.include? "O").to eq(true)
  end

  it "computer makes second move on Hard level, if center is taken computer takes any corner" do
    board = Board.create
    game = Game.create(board_id: board.id, difficulty_level: "Hard", game_type: 'hvc')
    game.board.setup
    player1 = Human.create(game_id: game.id, symbol: "X")
    player2 = Computer.create(game_id: game.id, symbol: "O")
    game.player1_id = player1.id
    game.player2_id = player2.id
    game.save
    game.board[4] = "X"
    game.make_computer_move(player2)
    expect(game.board.corners.any? {|spot| spot == "O"}).to eq(true)
  end

  it "computer makes second move on Hard level, if corner is taken computer takes center" do
    board = Board.create
    game = Game.create(board_id: board.id, difficulty_level: "Hard", game_type: 'hvc')
    game.board.setup
    player1 = Human.create(game_id: game.id, symbol: "X")
    player2 = Computer.create(game_id: game.id, symbol: "O")
    game.player1_id = player1.id
    game.player2_id = player2.id
    game.save
    game.board[game.board.corners[rand(0..3)]] = "X"
    game.make_computer_move(player2)
    expect(game.board[4]).to eq("O")
  end

  it "computer ('O') makes second move on Hard level, if edge is taken computer makes corresponding move" do
    board = Board.create
    game = Game.create(board_id: board.id, difficulty_level: "Hard", game_type: 'hvc')
    game.board.setup
    player1 = Human.create(game_id: game.id, symbol: "X")
    player2 = Computer.create(game_id: game.id, symbol: "O")
    game.player1_id = player1.id
    game.player2_id = player2.id
    game.save
    game.board[game.board.edges[rand(0..3)]] = "X"
    first_spot = game.board.first_move
    game.make_computer_move(player2)
    comp_move = game.board.spaces_array.index("O")
    expected_comp_move = game.board.edge_first_minimax_moves[first_spot]
    expect(comp_move).to eq(expected_comp_move)
  end

  it "computer ('X') makes second move on Hard level, if edge is taken computer makes corresponding move" do
    board = Board.create
    game = Game.create(board_id: board.id, difficulty_level: "Hard", game_type: 'hvc')
    game.board.setup
    player1 = Human.create(game_id: game.id, symbol: "O")
    player2 = Computer.create(game_id: game.id, symbol: "X")
    game.player1_id = player1.id
    game.player2_id = player2.id
    game.save
    game.board[game.board.edges[rand(0..3)]] = "O"
    first_spot = game.board.first_move
    game.make_computer_move(player2)
    comp_move = game.board.spaces_array.index("X")
    expected_comp_move = game.board.edge_first_minimax_moves[first_spot]
    expect(comp_move).to eq(expected_comp_move)
  end

# ~~~~ Actual minimax moves (NOT hard-coded) ~~~~

  it "computer takes spot to win rather than to block opponent or random" do
    board = Board.create
    game = Game.create(board_id: board.id, difficulty_level: "Hard", game_type: 'hvc')
    game.board.setup
    player1 = Human.create(game_id: game.id, symbol: "O")
    player2 = Computer.create(game_id: game.id, symbol: "X")
    game.player1_id = player1.id
    game.player2_id = player2.id
    game.save
    game.board[0] = "O"
    game.board[1] = "O"
    game.board[3] = "X"
    game.board[4] = "X"
    game.make_computer_move(player2)
    expect(game.board[5]).to eq("X")
  end

  it "computer takes spot to block opponent" do
    board = Board.create
    game = Game.create(board_id: board.id, difficulty_level: "Hard", game_type: 'hvc')
    game.board.setup
    player1 = Human.create(game_id: game.id, symbol: "O")
    player2 = Computer.create(game_id: game.id, symbol: "X")
    game.player1_id = player1.id
    game.player2_id = player2.id
    game.save
    game.board[0] = "O"
    game.board[1] = "O"
    game.board[3] = "X"
    game.make_computer_move(player2)
    expect(game.board[2]).to eq("X")
  end

  it "computer takes center spot since it is best move" do
    board = Board.create
    game = Game.create(board_id: board.id, difficulty_level: "Hard", game_type: 'hvc')
    game.board.setup
    player1 = Human.create(game_id: game.id, symbol: "X")
    player2 = Computer.create(game_id: game.id, symbol: "O")
    game.player1_id = player1.id
    game.player2_id = player2.id
    game.save
    game.board[0] = "O"
    game.board[3] = "X"
    game.make_computer_move(player2)
    expect(game.board[4]).to eq("O")
  end

  it "always ties between two computers using minimax" do
    board = Board.create
    game = Game.create(board_id: board.id, difficulty_level: "Hard", game_type: 'cvc')
    game.board.setup
    player1 = Computer.create(game_id: game.id, symbol: "O")
    player2 = Computer.create(game_id: game.id, symbol: "X")
    game.player1_id = player1.id
    game.player2_id = player2.id
    game.save
    game.make_computer_move(player1) # hard-coded move
    game.make_computer_move(player2) # hard-coded move
    game.make_computer_move(player1) # not hard-coded from here down
    game.make_computer_move(player2)
    game.make_computer_move(player1)
    game.make_computer_move(player2)
    game.make_computer_move(player1)
    game.make_computer_move(player2)
    game.make_computer_move(player1)
    expect(game.tie(game.board)).to eq(true)
    expect(game.someone_wins(game.board)).to eq(false)
    expect(game.game_is_over(game.board)).to eq(true)
  end

# -------------------------------------------------------
# TEST METHODS - winner(board)
#
# 'winning_possibilities(board)' inside 'winner(board)'
# -------------------------------------------------------

  it "identifies winner (computer player with 'O' symbol ACROSS TOP ROW) - hvc on 'Hard'" do
    board = Board.create
    game = Game.create(board_id: board.id, difficulty_level: "Hard", game_type: 'hvc')
    game.board.setup
    player1 = Human.create(game_id: game.id, symbol: "X")
    player2 = Computer.create(game_id: game.id, symbol: "O")
    game.player1_id = player1.id
    game.player2_id = player2.id
    game.save
    game.board[0] = "O"
    game.board[1] = "O"
    game.board[2] = "O"
    game.board[3] = "X"
    game.board[4] = "X"
    game.board[5] = "O"
    game.board[7] = "X"
    #  O | O | O 
    # ===+===+===
    #  X | X | O  
    # ===+===+===
    #    | X |  
    expect(game.winner(game.board)).to eq(game.player2)
  end

  it "identifies winner (human player with 'X' symbol ACROSS MIDDLE ROW) - hvc on 'Medium'" do
    board = Board.create
    game = Game.create(board_id: board.id, difficulty_level: "Medium", game_type: 'hvc')
    game.board.setup
    player1 = Human.create(game_id: game.id, symbol: "X")
    player2 = Computer.create(game_id: game.id, symbol: "O")
    game.player1_id = player1.id
    game.player2_id = player2.id
    game.save
    game.board[0] = "X"
    game.board[1] = "O"
    game.board[2] = "O"
    game.board[3] = "X"
    game.board[4] = "X"
    game.board[5] = "X"
    game.board[7] = "O"
    #  X | O | O 
    # ===+===+===
    #  X | X | X  
    # ===+===+===
    #    | O |  
    expect(game.winner(game.board)).to eq(game.player1)
  end

  it "identifies winner (human player with 'X' symbol ACROSS BOTTOM ROW) - hvc on 'Easy'" do
    board = Board.create
    game = Game.create(board_id: board.id, difficulty_level: "Easy", game_type: 'hvc')
    game.board.setup
    player1 = Human.create(game_id: game.id, symbol: "X")
    player2 = Computer.create(game_id: game.id, symbol: "O")
    game.player1_id = player1.id
    game.player2_id = player2.id
    game.save
    game.board[0] = "O"
    game.board[1] = "X"
    game.board[2] = "O"
    game.board[3] = "O"
    game.board[6] = "X"
    game.board[7] = "X"
    game.board[8] = "X"
    #  O | X | O 
    # ===+===+===
    #  O |   |   
    # ===+===+===
    #  X | X | X 
    expect(game.winner(game.board)).to eq(game.player1)
  end

  it "identifies winner (human player with 'O' symbol on FAR LEFT COLUMN) - hvh" do
    board = Board.create
    game = Game.create(board_id: board.id, game_type: 'hvh')
    game.board.setup
    player1 = Human.create(game_id: game.id, symbol: "X")
    player2 = Human.create(game_id: game.id, symbol: "O")
    game.player1_id = player1.id
    game.player2_id = player2.id
    game.save
    game.board[0] = "O"
    game.board[1] = "X"
    game.board[2] = "X"
    game.board[3] = "O"
    game.board[6] = "O"
    game.board[7] = "X"
    game.board[8] = "X"
    #  O | X | X 
    # ===+===+===
    #  O |   |   
    # ===+===+===
    #  O | X | X 
    expect(game.winner(game.board)).to eq(game.player2)
  end

  it "identifies winner (human player with 'X' symbol on MIDDLE COLUMN) - hvh" do
    board = Board.create
    game = Game.create(board_id: board.id, game_type: 'hvh')
    game.board.setup
    player1 = Human.create(game_id: game.id, symbol: "X")
    player2 = Human.create(game_id: game.id, symbol: "O")
    game.player1_id = player1.id
    game.player2_id = player2.id
    game.save
    game.board[0] = "O"
    game.board[1] = "X"
    game.board[2] = "X"
    game.board[4] = "X"
    game.board[5] = "O"
    game.board[6] = "O"
    game.board[7] = "X"
    game.board[8] = "O"
    #  O | X | X 
    # ===+===+===
    #    | X | O 
    # ===+===+===
    #  O | X | O 
    expect(game.winner(game.board)).to eq(game.player1)
  end

  it "identifies winner (computer player with 'X' symbol on FAR RIGHT COLUMN) - cvc on 'Easy'" do
    board = Board.create
    game = Game.create(board_id: board.id, difficulty_level: "Easy", game_type: 'cvc')
    game.board.setup
    player1 = Computer.create(game_id: game.id, symbol: "X")
    player2 = Computer.create(game_id: game.id, symbol: "O")
    game.player1_id = player1.id
    game.player2_id = player2.id
    game.save
    game.board[0] = "O"
    game.board[1] = "O"
    game.board[2] = "X"
    game.board[4] = "O"
    game.board[5] = "X"
    game.board[6] = "O"
    game.board[7] = "X"
    game.board[8] = "X"
    #  O | O | X 
    # ===+===+===
    #    | O | X 
    # ===+===+===
    #  O | X | X 
    expect(game.winner(game.board)).to eq(game.player1)
  end

  it "identifies winner (computer player with 'O' symbol on TOP LEFT TO BOTTOM RIGHT DIAGONAL) - cvc on 'Medium'" do
    board = Board.create
    game = Game.create(board_id: board.id, difficulty_level: "Medium", game_type: 'cvc')
    game.board.setup
    player1 = Computer.create(game_id: game.id, symbol: "X")
    player2 = Computer.create(game_id: game.id, symbol: "O")
    game.player1_id = player1.id
    game.player2_id = player2.id
    game.save
    game.board[0] = "O"
    game.board[1] = "O"
    game.board[2] = "X"
    game.board[4] = "O"
    game.board[5] = "X"
    game.board[6] = "O"
    game.board[7] = "X"
    game.board[8] = "O"
    #  O | O | X 
    # ===+===+===
    #    | O | X 
    # ===+===+===
    #  O | X | O 
    expect(game.winner(game.board)).to eq(game.player2)
  end

  it "identifies winner (computer player with 'X' symbol on TOP RIGHT TO BOTTOM LEFT DIAGONAL) - cvc on 'Hard'" do
    board = Board.create
    game = Game.create(board_id: board.id, difficulty_level: "Hard", game_type: 'cvc')
    game.board.setup
    player1 = Computer.create(game_id: game.id, symbol: "X")
    player2 = Computer.create(game_id: game.id, symbol: "O")
    game.player1_id = player1.id
    game.player2_id = player2.id
    game.save
    game.board[0] = "O"
    game.board[1] = "O"
    game.board[2] = "X"
    game.board[4] = "X"
    game.board[5] = "O"
    game.board[6] = "X"
    game.board[7] = "X"
    game.board[8] = "O"
    #  O | O | X 
    # ===+===+===
    #    | X | O 
    # ===+===+===
    #  X | X | O 
    expect(game.winner(game.board)).to eq(game.player1)
  end

# ----------------------------------------------------
# TEST METHOD - as_json
# ----------------------------------------------------


  it "provides as_json data for current game" do
    board = Board.create
    game = Game.create(board_id: board.id, difficulty_level: "Hard", game_type: 'cvc')
    game.board.setup
    player1 = Computer.create(game_id: game.id, symbol: "X")
    player2 = Computer.create(game_id: game.id, symbol: "O")
    game.player1_id = player1.id
    game.player2_id = player2.id
    game.save
    game.board[0] = "O"
    game.board[1] = "O"
    game.board[2] = "X"
    game.board[4] = "X"
    game.board[5] = "O"
    game.board[6] = "X"
    game.board[7] = "X"
    game.board[8] = "O"
    game.switch_player(game.player1)
    # expect(game.as_json.id).to eq(game.id)
    # expect(game.as_json.board_id).to eq(game.board.id)
    # expect(game.as_json.board).to eq(game.board)
    # expect(game.as_json.game_type).to eq('cvc')
    # expect(game.as_json.difficulty_level).to eq('Hard')
    # expect(game.as_json.player1).to eq(game.player1)
    # expect(game.as_json.player2).to eq(game.player2)
    # expect(game.as_json.winner).to eq(game.player1)
    # expect(game.as_json.tie).to eq(false)
    # expect(game.as_json.next_player).to eq(game.player2)
    expect(game.as_json).to eq(game.as_json)
  end

end
