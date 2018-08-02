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
    # @player1 = player1
    # @player2 = player2
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
    if self.game_type == 'hvh' || self.game_type == 'hvc'
      player1 = Human.find(self.player1_id)
    else 
      player1 = Computer.find(self.player1_id)
    end
    return player1
  end

  def player2
    if self.game_type == 'hvc' || self.game_type == 'cvc'
      player2 = Computer.find(self.player2_id)
    else 
      player2 = Human.find(self.player2_id)
    end
    return player2
  end

  def switch_player
    @current_player == @player1 ? @current_player = @player2 : @current_player = @player1
  end

  def opposite_player(player)
    player == @player1 ? @player2 : @player1
  end

  def make_human_move(player, space)
    self.board[space] = player.symbol
    self.board.save
  end

  def make_computer_move(player, space)
  end

  def get_score(board, depth)
    winner(board)
    if @winner == @current_player
      return 10 - depth
    elsif @winner == opposite_player(@current_player)
      return depth - 10
    else
      return 0
    end
  end

  def minimax(board, player, depth)
    if game_is_over(board)
      return get_score(board, depth)
    end
    depth += 1
    scores = []
    moves = []
    available_spaces(board).each do |space|
      new_board = board.dup # temporary representation of current board
      new_board[space.to_i] = player.make_move # make potential move on temp board 
      scores << minimax(new_board, opposite_player(player), depth) # if game over, store score in array to eventually pass up best score
      moves << space # store move that correlates to stored score above
    end
    
    if self.difficulty_level == "Hard"
      if @current_player == player
        # This is the max calculation
        max_score_index = scores.each_with_index.max[1]
        @choice = moves[max_score_index]
        return scores[max_score_index]
      else
        # This is the min calculation
        min_score_index = scores.each_with_index.min[1]
        @choice = moves[min_score_index]
        return scores[min_score_index]
      end
    else # may get rid of this - for Easy mode, basically try NOT to win
      if @current_player == player
        # This is the min calculation
        min_score_index = scores.each_with_index.min[1]
        @choice = moves[min_score_index]
        return scores[min_score_index]
      else
        # This is the max calculation
        max_score_index = scores.each_with_index.max[1]
        @choice = moves[max_score_index]
        return scores[max_score_index]
      end
    end
  end

  def winning_possibilities(b)
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

  def tie(board)
    board.all? { |s| s == "X" || s == "O" }
  end

  def game_is_over(board)
    self.someone_wins(board) || self.tie(board)
  end

  def winner(board)
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

  def winning_message
    if @winner == @player1
      return "#{@names[@player1]} wins! Great job #{@names[@player1]}! Play again!"
    elsif @winner == @player2
      return "#{@names[@player2]} wins! Nice try #{@names[@player1]}! Play again!"
    else
      return "It was a tie! Play again!"
    end
  end

  def as_json
    {
      id: id,
      created_at: created_at,
      board_id: board_id,
      game_type: game_type,
      difficulty_level: difficulty_level,
      player1: player1,
      player2: player2,
      winner: winner(board)
    }
  end

end
