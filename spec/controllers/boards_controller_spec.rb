require 'rails_helper'

RSpec.describe V1::BoardsController, type: :controller do

  describe "POST create" do

    it "creates a new board and sets up with corresponding numbers in each spot" do
      post :create
      expect(Board.last[0]).to eq("0")
      expect(Board.last[1]).to eq("1")
      expect(Board.last[2]).to eq("2")
      expect(Board.last[3]).to eq("3")
      expect(Board.last[4]).to eq("4")
      expect(Board.last[5]).to eq("5")
      expect(Board.last[6]).to eq("6")
      expect(Board.last[7]).to eq("7")
      expect(Board.last[8]).to eq("8")
    end

  end

end
