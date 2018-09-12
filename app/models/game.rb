class Game < ApplicationRecord
  has_many :humen
  has_many :computers
  belongs_to :board, optional: true

  def setup(params)
    self.game_type = params[:game_type]
    self.difficulty_level = params[:level]
    self.board_id = params[:board_id]
  end

  def player_setup(player1, player2, names, who_is_x)
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
      player.easy_eval_board(self)
    elsif difficulty_level == 'Medium'
      player.medium_eval_board(self)
    else
      player.hard_eval_board(self)
    end
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
      computer_response: player2.class == Computer ? player2.selected_response(self) : nil,
      difficulty_level: difficulty_level,
      player1: player1.as_json,
      player2: player2.as_json,
      winner: winner(board).as_json,
      tie: tie(board),
      next_player: next_player.as_json
    }
  end

end