require 'rails_helper'

RSpec.describe Computer, type: :model do

# --------------------------------------------------------------------------------
# TEST METHODS - responses() // selected_response(game) // game_over_message(game)
# --------------------------------------------------------------------------------

  it "returns the string 'Here we go!' when game is started" do
    board = Board.create
    game = Game.create(board_id: board.id, difficulty_level: "Medium", game_type: 'hvc')
    game.board.setup
    player1 = Human.create(game_id: game.id, symbol: "O")
    player2 = Computer.create(game_id: game.id, symbol: "X")
    game.player1_id = player1.id
    game.player2_id = player2.id
    game.save
    game.board[0] = "O"
    expect(player2.selected_response(game)).to eq("Here we go!")
  end

  it "returns a random string from responses() at any point in game that is not the start or end" do
    board = Board.create
    game = Game.create(board_id: board.id, difficulty_level: "Hard", game_type: 'hvc')
    game.board.setup
    player1 = Human.create(game_id: game.id, symbol: "X")
    player2 = Computer.create(game_id: game.id, symbol: "O")
    game.player1_id = player1.id
    game.player2_id = player2.id
    game.save
    game.board[0] = "O"
    game.board[1] = "X"
    game.board[2] = "O"
    game.board[3] = "X"
    expect(player2.responses.include? player2.selected_response(game)).to eq(true)
  end

  it "returns appropriate game_over_message when player1 wins" do
    board = Board.create
    game = Game.create(board_id: board.id, difficulty_level: "Hard", game_type: 'hvc')
    game.board.setup
    player1 = Human.create(game_id: game.id, symbol: "X")
    player2 = Computer.create(game_id: game.id, symbol: "O")
    game.player1_id = player1.id
    game.player2_id = player2.id
    game.save
    player1.name = "Burt"
    player2.name = "Ernie"
    player1.save
    player2.save
    game.board[0] = "O"
    game.board[1] = "X"
    game.board[2] = "O"
    game.board[3] = "X"
    game.board[4] = "X"
    game.board[5] = "O"
    game.board[7] = "X"
    #  O | X | O
    # ===+===+===
    #  X | X | O 
    # ===+===+===
    #    | X |  
    expect(player2.selected_response(game)).to eq("Great job Burt! Let's play again!")
  end

  it "returns appropriate game_over_message when player2 (self) wins" do
    board = Board.create
    game = Game.create(board_id: board.id, difficulty_level: "Hard", game_type: 'hvc')
    game.board.setup
    player1 = Human.create(game_id: game.id, symbol: "O")
    player2 = Computer.create(game_id: game.id, symbol: "X")
    game.player1_id = player1.id
    game.player2_id = player2.id
    game.save
    player1.name = "Burt"
    player2.name = "Ernie"
    player1.save
    player2.save
    game.board[0] = "O"
    game.board[1] = "X"
    game.board[2] = "O"
    game.board[3] = "X"
    game.board[4] = "X"
    game.board[5] = "O"
    game.board[7] = "X"
    #  O | X | O
    # ===+===+===
    #  X | X | O 
    # ===+===+===
    #    | X |  
    expect(player2.selected_response(game)).to eq("I win! Nice try Burt! Let's play again!")
  end

  it "returns appropriate game_over_message when game ends in tie" do
    board = Board.create
    game = Game.create(board_id: board.id, difficulty_level: "Hard", game_type: 'hvc')
    game.board.setup
    player1 = Human.create(game_id: game.id, symbol: "O")
    player2 = Computer.create(game_id: game.id, symbol: "X")
    game.player1_id = player1.id
    game.player2_id = player2.id
    game.save
    player1.name = "Burt"
    player2.name = "Ernie"
    player1.save
    player2.save
    game.board[0] = "O"
    game.board[1] = "X"
    game.board[2] = "O"
    game.board[3] = "X"
    game.board[4] = "X"
    game.board[5] = "O"
    game.board[6] = "O"
    game.board[7] = "O"
    game.board[8] = "X"
    #  O | X | O
    # ===+===+===
    #  X | X | O 
    # ===+===+===
    #  O | O | X 
    expect(player2.selected_response(game)).to eq("It was a tie! Let's play again!")
  end


#                                *******************
# -----------------------------------------------------------------------------------
# To avoid redundancy, all other Computer model methods, which were tested in 
# game_spec will not be tested again here --- please run game_spec test to test them
# -----------------------------------------------------------------------------------
#                                ********************

end
