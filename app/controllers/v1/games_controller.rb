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
    
    render json: game.as_json
  end

  def update
    game = Game.find(params[:id])
    params[:player][:id] == game.player1.id ? player = game.player1 : player = game.player2
    space = params[:space]
    board = game.board

    if player.class == Human
      game.make_human_move(player, space)
    else
      game.make_computer_move(player, space)
    end

    render json: game.as_json
  end

end