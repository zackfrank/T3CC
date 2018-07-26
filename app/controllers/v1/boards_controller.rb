class V1::BoardsController < ApplicationController

  def index
    render json: {text: "Hello"}
  end

  def create
    board = Board.new
    board.spaces = [0, 1, 2, 3, 4, 5, 6, 7, 8]
    board.save
    render json: board.as_json
  end

  def update
    board = Board.find_by(id: params[:id])
    board.spaces = params[:spaces]
    board.save
    render json: board.as_json
  end

end
