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
        :who_is_x => 'player1', 
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
        :who_is_x => 'player2', 
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
        :who_is_x => 'player2', 
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

    before(:all) do
      @board = Board.new
      @board.setup
      @board.save

      @game = Game.new
      @game.board_id = @board.id
      @game.save
    end

    # it "makes player1 (human) move on 'hvh'" do
    #   post :create, :params => {
      #   :game_type => 'cvc', 
      #   :level => 'Medium',
      #   :board_id => @board.id, 
      #   :names => ["David", "Elliot"], 
      #   :who_is_x => 'player2', 
      #   :first => 'player2'
      # }
    #   patch :update, :params => {
    #     :id => @game.id, 
    #     :board_id => @board.id, 
    #     :names => ["Zack", "Daniel"], 
    #     :who_is_x => 'player1', 
    #     :first => 'player1'
    #   }
    #   expect(Game.last.game_type).to eq('hvh')
    #   expect(Game.last.board_id).to eq(@board.id)
    #   expect(Game.last.player1.name).to eq("Zack")
    #   expect(Game.last.player2.name).to eq("Daniel")
    #   expect(Game.last.player1.symbol).to eq("X")
    #   expect(Game.last.player2.symbol).to eq("O")
    #   expect(Human.second_to_last.id).to eq(Game.last.player1_id)
    #   expect(Human.last.id).to eq(Game.last.player2_id)
    #   expect(Human.last.game_id).to eq(Game.last.id)
    #   expect(Human.second_to_last.game_id).to eq(Game.last.id)
    # end

  end

end
