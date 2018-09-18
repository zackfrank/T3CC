class Game < ApplicationRecord
  has_many :humen
  has_many :computers
  belongs_to :board, optional: true

  def setup(params)
    self.game_type = params[:game_type]
    self.difficulty_level = params[:level]
    self.board_id = params[:board_id]
    self.player_setup(params[:player1], params[:player2], params[:names], params[:who_is_x])
  end

  def player_setup(player1, player2, names, who_is_x)
    player1[:player_type] == "Human" ? player1 = Human.find(player1[:id]) : player1 = Computer.find(player1[:id])
    player2[:player_type] == "Human" ? player2 = Human.find(player2[:id]) : player2 = Computer.find(player2[:id])
    player1.game_id = self.id
    player2.game_id = self.id
    if who_is_x == 'player1'
      player1.symbol = "X"
      player2.symbol = "O"
    else
      player1.symbol = "O"
      player2.symbol = "X"
    end
    player1.name = names[0]
    player2.name = names[1]
    player1.save
    player2.save
    self.player1_id = player1.id
    self.player2_id = player2.id
    self.save
  end

  def update(params)
    params[:player][:id].to_i == player1.id ? player = player1 : player = player2 #identify player
    space = params[:space]

    if self.game_type == 'hvh'
      self.make_human_move(player, space)
      self.switch_player(player) # sends next 'current player' to front end
    elsif self.game_type == 'hvc'
      if player == player1
        self.make_human_move(player, space)
      end
      unless self.game_is_over(self.board)
        self.make_computer_move(player2)
        self.switch_player(player2) # switch back to player 1
      end
    elsif self.game_type == 'cvc'
      self.make_computer_move(player)
      self.switch_player(player)
    end
  end

  def player1
    if self.game_type == 'cvc'
      player1 = Computer.find(self.player1_id)
    else 
      player1 = Human.find(self.player1_id)
    end
    return player1
  end

  def player2
    if self.game_type == 'hvh'
      player2 = Human.find(self.player2_id)
    else 
      player2 = Computer.find(self.player2_id)
    end
    return player2
  end

  def switch_player(current_player)
    current_player == player1 ? @next_player = player2 : @next_player = player1
  end

  def next_player
    @next_player
  end

  def opposite_player(player)
    player == player1 ? player2 : player1
  end

  def make_human_move(player, space)
    self.board[space] = player.symbol
    self.board.save
  end

  def make_computer_move(player)
    if difficulty_level == 'Easy'
      @computer_move = player.easy_eval_board(self)
    elsif difficulty_level == 'Medium'
      @computer_move = player.medium_eval_board(self)
    else
      @computer_move = player.hard_eval_board(self)
    end
  end

  def computer_move
    @computer_move
  end

  def winning_possibilities(b) #possible rows, columns, and diagonals for a win
    [
      [b[0], b[1], b[2]],
      [b[3], b[4], b[5]],
      [b[6], b[7], b[8]],
      [b[0], b[3], b[6]],
      [b[1], b[4], b[7]],
      [b[2], b[5], b[8]],
      [b[0], b[4], b[8]],
      [b[2], b[4], b[6]]
    ]
  end

  def someone_wins(board) #returns boolean if there is a winner
    winning_possibilities(board).any? {|possible_win| possible_win.uniq.length == 1 }
  end

  def tie(board) #returns boolean if there is a tie
    board.spaces_array.all? { |s| s == "X" || s == "O" } && !winner(board)
  end

  def game_is_over(board) #returns boolean if either winner or tie
    someone_wins(board) || tie(board)
  end

  def winner(board) #returns winner or nil
    p1symbol = self.player1.symbol
    p2symbol = self.player2.symbol
    if winning_possibilities(board).detect {|possible_win| possible_win.all? p1symbol }
      return player1
    elsif winning_possibilities(board).detect {|possible_win| possible_win.all? p2symbol }
      return player2
    else
      return false
    end
  end

  def as_json
    {
      id: id,
      created_at: created_at,
      board_id: board_id,
      board: board,
      game_type: game_type,
      computer_response: game_type != 'hvh' ? player2.selected_response(self) : nil,
      difficulty_level: difficulty_level,
      player1: player1.as_json,
      player2: player2.as_json,
      game_is_over: game_is_over(board),
      winner: winner(board).as_json,
      tie: tie(board),
      next_player: next_player.as_json,
      computer_move: computer_move
    }
  end

end