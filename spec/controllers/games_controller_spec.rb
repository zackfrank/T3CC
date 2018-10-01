require 'rails_helper'

RSpec.describe V1::GamesController, type: :controller do
  
  describe "POST create" do

    before(:all) do
      @board = Board.new
      @board.setup
      @board.save
    end

    it "creates a new 'hvh' game" do
      post :create, :params => {
        :game_type => 'hvh', 
        :board_id => @board.id, 
        :names => ["Zack", "Daniel"], 
        :symbols => ["X", "O"],
        :first => 'player1'
      }
      expect(Game.last.game_type).to eq('hvh')
      expect(Game.last.board_id).to eq(@board.id)
      expect(Game.last.player1.name).to eq("Zack")
      expect(Game.last.player2.name).to eq("Daniel")
      expect(Game.last.player1.symbol).to eq("X")
      expect(Game.last.player2.symbol).to eq("O")
      expect(Human.second_to_last.id).to eq(Game.last.player1_id)
      expect(Human.last.id).to eq(Game.last.player2_id)
      expect(Human.last.game_id).to eq(Game.last.id)
      expect(Human.second_to_last.game_id).to eq(Game.last.id)
    end

    it "creates a new 'Easy' 'hvc' game" do
      post :create, :params => {
        :game_type => 'hvc', 
        :level => 'Easy',
        :board_id => @board.id, 
        :names => ["Brad", "Charles"], 
        :symbols => ["O", "X"],
        :first => 'player2'
      }
      expect(Game.last.game_type).to eq('hvc')
      expect(Game.last.difficulty_level).to eq('Easy')
      expect(Game.last.board_id).to eq(@board.id)
      expect(Game.last.player1.name).to eq("Brad")
      expect(Game.last.player2.name).to eq("Charles")
      expect(Game.last.player1.symbol).to eq("O")
      expect(Game.last.player2.symbol).to eq("X")
      expect(Human.last.id).to eq(Game.last.player1_id)
      expect(Computer.last.id).to eq(Game.last.player2_id)
      expect(Human.last.game_id).to eq(Game.last.id)
      expect(Computer.last.game_id).to eq(Game.last.id)
    end

    it "creates a new 'Medium' 'cvc' game" do
      post :create, :params => {
        :game_type => 'cvc', 
        :level => 'Medium',
        :board_id => @board.id, 
        :names => ["David", "Elliot"], 
        :symbols => ["O", "X"],
        :first => 'player2'
      }
      expect(Game.last.game_type).to eq('cvc')
      expect(Game.last.difficulty_level).to eq('Medium')
      expect(Game.last.board_id).to eq(@board.id)
      expect(Game.last.player1.name).to eq("David")
      expect(Game.last.player2.name).to eq("Elliot")
      expect(Game.last.player1.symbol).to eq("O")
      expect(Game.last.player2.symbol).to eq("X")
      expect(Computer.second_to_last.id).to eq(Game.last.player1_id)
      expect(Computer.last.id).to eq(Game.last.player2_id)
      expect(Computer.second_to_last.game_id).to eq(Game.last.id)
      expect(Computer.last.game_id).to eq(Game.last.id)
    end

  end

  describe "PATCH update" do

    before(:each) do
      @board = Board.new
      @board.setup
      @board.save
    end

    it "makes human move on 'hvh'" do
      post :create, :params => {
        :game_type => 'hvh', 
        :board_id => @board.id, 
        :names => ["Fred", "George"], 
        :symbols => ["O", "X"]
      }
      patch :update, params: 
      {
        id: Game.last.id, 
        player: {
          id: Game.last.player2.id
          }, 
        space: 4
      }
      expect(Game.last.board[4]).to eq("X")
    end

    it "makes computer move on 'Easy' 'hvc'" do
      post :create, :params => {
        :game_type => 'hvc', 
        :level => 'Easy',
        :board_id => @board.id, 
        :names => ["Hector", "Isaac"], 
        :symbols => ["X", "O"],
      }
      patch :update, params: 
      {
        id: Game.last.id, 
        player: {
          id: Game.last.player2.id
          }
      }
      expect(Game.last.board.spaces_array.include? "O").to eq(true)
    end

    it "makes first computer move on space 4 on 'Medium' 'hvc'" do
      post :create, :params => {
        :game_type => 'hvc', 
        :level => 'Medium',
        :board_id => @board.id, 
        :names => ["Hector", "Isaac"], 
        :symbols => ["X", "O"],
      }
      patch :update, params: 
      {
        id: Game.last.id, 
        player: {
          id: Game.last.player2.id
          }
      }
      expect(Game.last.board[4]).to eq("O")
    end

    # it "makes computer move to block human from winning on 'Medium' 'hvc'" do
    #   post :create, :params => {
    #     :game_type => 'hvc', 
    #     :level => 'Medium',
    #     :board_id => @board.id, 
    #     :names => ["Hector", "Isaac"], 
    #     :who_is_x => 'player1', 
    #   }
    #   patch :update, params: 
    #   {
    #     id: Game.last.id, 
    #     player: {id: Human.last.id},
    #     space: 0
    #   }
    #   # patch :update, params: 
    #   # {
    #   #   id: Game.last.id, 
    #   #   player: {
    #   #     id: Game.last.player1.id
    #   #     },
    #   #   space: 1
    #   # }
    #   # patch :update, params: 
    #   # {
    #   #   id: Game.last.id, 
    #   #   player: {
    #   #     id: Game.last.player2.id
    #   #     }
    #   # }
    #   expect(Game.last.board.spaces_array).to eq("O")
    # end

  end

end
