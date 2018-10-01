class Game < ApplicationRecord
  has_many :humen
  has_many :computers
  belongs_to :board, optional: true

  # setup() notes:
  #
  # Used in Games#create method in the Games controller for post requests
  # Updates database with game parameters decided by user on frontend
  # Assumes board has already been created
  def setup(params)
    self.game_type = params[:game_type]
    self.difficulty_level = params[:level]
    self.board_id = params[:board_id]
    self.player_setup(params[:player1], params[:player2], params[:names], params[:symbols])
  end


  # player_setup() notes:
  #
  # This is only used in the Games#create method in the Games controller for post requests
  # Called by setup() -- above -- which is called from Games controller
  # Assumes players have already been created
  # Updates game_id for each player, player symbols, player names
  # Also saves id of each player in Games table to be used to pull players based on ids for patch requests
  # See player1 and player2 methods below to see how player ids are used
  def player_setup(player1, player2, names, symbols)
    player1[:player_type] == "Human" ? player1 = Human.find(player1[:id]) : player1 = Computer.find(player1[:id])
    player2[:player_type] == "Human" ? player2 = Human.find(player2[:id]) : player2 = Computer.find(player2[:id])
    player1.game_id = self.id
    player2.game_id = self.id
    player1.symbol = symbols[0]
    player2.symbol = symbols[1]
    player1.name = names[0]
    player2.name = names[1]
    player1.save
    player2.save
    self.player1_id = player1.id
    self.player2_id = player2.id
    self.save
  end

  # update() notes:
  #
  # This is used in the Games#update method in the Games controller for every patch request
  # Human moves require params: space and player
  # Computer moves require only player (since computer move is determined on backend)
  def update(params)
    params[:player][:id].to_i == player1.id ? player = player1 : player = player2 # identify player
    space = params[:space]

    if self.game_type == 'hvh'
      self.make_human_move(player, space)
      self.switch_player(player) # sends next 'current player' to front end
    elsif self.game_type == 'hvc'
      if player == player1
        # This will be true every time except for when player2 (computer), starts the game
        self.make_human_move(player, space)
      end
      unless self.game_is_over(self.board)
        # in hvc gameplay, unless human move ends the game:
        # computer move is made every time human player makes a move
        self.make_computer_move(player2)
        self.switch_player(player2) # switch back to player 1
      end
    elsif self.game_type == 'cvc'
      self.make_computer_move(player)
      self.switch_player(player) # sends next 'current player' to front end
    end
  end


  # ------------------------------------------------------
  # player1 and player2 query database to find 
  # player1 and player2 depending on game type
  # ------------------------------------------------------
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
  # ------------------------------------------------------
  # ------------------------------------------------------


  # updates board to register move human player made on frontend
  def make_human_move(player, space)
    self.board[space] = player.symbol
    self.board.save
  end

  # sends message to Computer model to retrieve computer move according to difficulty level
  def make_computer_move(player)
    if difficulty_level == 'Easy'
      @computer_move = player.make_easy_move(self)
    elsif difficulty_level == 'Medium'
      @computer_move = player.make_medium_move(self)
    else
      @computer_move = player.make_hard_move(self)
    end
  end

  # used to send next player to frontend
  def switch_player(current_player)
    current_player == player1 ? @next_player = player2 : @next_player = player1
  end

  # boolean: returns true if game ends with either winner or tie
  def game_is_over(board)
    someone_wins(board) || tie(board)
  end

  # returns winning player hash/object or false if no winner
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

  # controls what is sent to frontend with each request
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

  private
    attr_reader :next_player, :computer_move

    # used to figure out if winner, who wins, or if tie game
    def winning_possibilities(b) # possible rows, columns, and diagonals for a win
      [
        [b[0], b[1], b[2]], # top row
        [b[3], b[4], b[5]], # middle row
        [b[6], b[7], b[8]], # bottom row
        [b[0], b[3], b[6]], # left column
        [b[1], b[4], b[7]], # middle column
        [b[2], b[5], b[8]], # right column
        [b[0], b[4], b[8]], # top left to bottom right diagonal
        [b[2], b[4], b[6]]  # top right to bottom left diagonal
      ]
    end

    # used in game_is_over; boolean: returns true if there is a winner
    def someone_wins(board)
      winning_possibilities(board).any? {|possible_win| possible_win.uniq.length == 1 }
    end

    # boolean: returns true if there is a tie
    def tie(board)
      board.spaces_array.all? { |s| s == "X" || s == "O" } && !winner(board)
    end

end