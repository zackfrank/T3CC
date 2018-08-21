class V1::BoardsController < ApplicationController

  def create
    board = Board.new
    board.setup
    board.save
    render json: board.as_json
  end

end
