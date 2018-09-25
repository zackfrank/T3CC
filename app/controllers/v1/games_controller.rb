class V1::GamesController < ApplicationController

  def create
    game = Game.create()
    game.setup(params)

    render json: game.as_json
  end

  def update
    game = Game.find(params[:id])
    game.update(params)

    render json: game.as_json
  end

end