class V1::GamesController < ApplicationController

  def create
    game = Game.create()

    game.setup(params)

    if params[:game_type] == 'hvh' # if human vs. human
      @player1 = Human.new
      @player2 = Human.new
    elsif params[:game_type] == 'hvc' # if human vs. computer
      @player1 = Human.new
      @player2 = Computer.new
    else                          # if computer vs. computer
      @player1 = Computer.new
      @player2 = Computer.new
    end

    game.player_setup(@player1, @player2, params[:names], params[:who_is_x])

    render json: game.as_json
  end

  def update
    game = Game.find(params[:id]) #identify game
    game.update(params)

    render json: game.as_json
  end

end