class V1::GamesController < ApplicationController

  def create
    game = Game.new()
    game.player_setup(params[:game_type])
    game.set_difficulty_level(params[:level])
    game.name_players(params[:names])
    game.set_symbols(params[:who_is_x])

    game.save
    render json: game.as_json
  end

end
