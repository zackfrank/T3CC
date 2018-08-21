class V1::GamesController < ApplicationController

  def create
    game = Game.create()

    game.setup(params)

    if params[:game_type] == 'hvh' #if human vs. human
      @player1 = Human.new
      @player2 = Human.new
    elsif params[:game_type] == 'hvc' #if human vs. computer
      @player1 = Human.new
      @player2 = Computer.new
    else                          # if computer vs. computer
      @player1 = Computer.new
      @player2 = Computer.new
    end

    game.player_setup(@player1, @player2, params[:names], params[:who_is_x])

    if params[:first].class == Computer
      update(params)
    end
    
    render json: game.as_json
  end

  def update
    game = Game.find(params[:id]) #identify game
    params[:player][:id] == game.player1.id ? player = game.player1 : player = game.player2 #identify player
    space = params[:space]
    board = game.board

    # game method to: 
    # if computer, make computer move based on diff level
    # send computer move to frontend
    # if cvc

    if game.game_type == 'hvh'
      game.make_human_move(player, space)
      game.switch_player(player) # sends next 'current player' to front end
    elsif game.game_type == 'hvc'
      if player == game.player1
        game.make_human_move(player, space)
      end
      unless game.game_is_over(game.board)
        game.make_computer_move(game.player2)
        game.switch_player(game.player2) # switch back to player 1
      end
    elsif game.game_type == 'cvc'
    end

    render json: game.as_json
  end

end