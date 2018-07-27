class V1::GamesController < ApplicationController

  def create
    game = Game.create()

    game.setup(params)

    if params[:game_type] == 'hvh'
      @player1 = Human.new
      @player2 = Human.new
    elsif params[:game_type] == 'hvc'
      @player1 = Human.new
      @player2 = Computer.new
    else
      @player1 = Computer.new
      @player2 = Computer.new
    end

    game.player_setup(@player1, @player2, params[:names], params[:who_is_x])

    game.player1.save
    game.player2.save
    game.player1_id = game.player1.id
    game.player2_id = game.player2.id
    game.save
    render json: game.as_json
  end

end
