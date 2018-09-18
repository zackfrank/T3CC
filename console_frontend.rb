require 'unirest'

class Game

  def initialize
    @board = Unirest.post("http://localhost:3000/v1/boards").body
    set_up
  end

  def set_up
    system "clear"
    puts "Welcome to Tic Tac Toe by Command Line Games, Inc!"
    # sleep(1.5)
    puts
    player_setup
    if @player2['player_type'] == "Computer"
      difficulty_level
    end
    name_players
    choose_symbol
    who_goes_first
    params = {
      game_type: @game_type,
      level: @difficulty_level,
      names: [@player1['name'], @player2['name']],
      who_is_x: @who_is_x,
      board_id: @board['id'],
      player1: @player1,
      player2: @player2
    }
    @game = Unirest.post("http://localhost:3000/v1/games", parameters: params).body

    @player1 = @game['player1']
    @player2 = @game['player2']
    @first_player == 'player1' ? @current_player = @player1 : @current_player = @player2
    @game_is_over = false
    # sleep(2.5)
    puts "Are you ready?!"
    # sleep(1.5)
    puts "Let's play!"
    # sleep(1)
    print "."
    # sleep(0.3)
    print "."
    # sleep(0.3)
    print "."
    # sleep(0.5)
    self.start_game
  end

  def player_setup
    game_types = [
      "[1] Human vs. Human",
      "[2] Human vs. Computer",
      "[3] Computer vs. Computer"
    ]
    puts "Please choose a game type:"
    puts "#{game_types[0]}"
    puts "#{game_types[1]}"
    puts "#{game_types[2]}"
    print "Entry: "
    @choice = gets.chomp.to_i
    @player1 = nil
    until @player1 do
      if @choice == 1
        @player1 = Unirest.post("http://localhost:3000/v1/humen").body
        @player2 = Unirest.post("http://localhost:3000/v1/humen").body
        @game_type = 'hvh'
      elsif @choice == 2
        @player1 = Unirest.post("http://localhost:3000/v1/humen").body
        @player2 = Unirest.post("http://localhost:3000/v1/computers").body
        @game_type = 'hvc'
      elsif @choice == 3
        @player1 = Unirest.post("http://localhost:3000/v1/computers").body
        @player2 = Unirest.post("http://localhost:3000/v1/computers").body
        @game_type = 'cvc'
      else
        puts
        puts "#{@choice} is not a valid entry. Please choose [1] [2] or [3]:"
        @choice = gets.chomp.to_i
      end
    end
    puts
    puts "Great! You chose #{game_types[@choice-1]}"
    puts "[ANY KEY] to continue."
    gets.chomp
    system "clear"
  end

  def difficulty_level
    puts "Please choose a difficulty level:"
    puts "[1] Easy"
    puts "[2] Medium"
    puts "[3] Hard"
    print "Entry: "
    level = gets.chomp.to_i
    @difficulty_level = nil
    until @difficulty_level do
      if level == 1
        @difficulty_level = "Easy"
      elsif level == 2
        @difficulty_level = "Medium"
      elsif level == 3
        @difficulty_level = "Hard"
      else
        puts
        puts "#{@game_type} is not a valid entry. Please choose [1] [2] or [3]:"
        level = gets.chomp.to_i
      end
    end
    puts
    puts "Great! You chose #{@difficulty_level}"
    puts "[ANY KEY] to continue."
    gets.chomp
    system "clear"
  end

  def name_players
    def enter_name
      print "Player 1, please enter your name: "
      name = gets.chomp
      until name != ""
        print "Please enter at least one alphanumeric character as your name: "
        name = gets.chomp
      end
      @player1['name'] = name
    end

    if @game_type == 'hvh'
      enter_name
      print "Please enter a name for Player 2: "
      name = gets.chomp
      until name != ""
        print "Please enter at least one alphanumeric character to name Player 2: "
        name = gets.chomp
      end
      @player2['name'] = name
    elsif @game_type == 'hvc'
      enter_name
      @player2['name'] = "Computer"
    elsif @game_type == 'cvc'
      @player1['name'] = "Computer 1"
      @player2['name'] = "Computer 2"
    end
  end

  def choose_symbol
    system "clear"
    print "Please choose the symbol for #{@player1['name']}"
    # sleep(0.8)
    print "."
    # sleep(0.3)
    print "."
    # sleep(0.3)
    print "."
    # sleep(0.5)
    puts
    until @player1['symbol'] == "X" || @player1['symbol'] == "O"
      puts "[1] for 'X'"
      puts "[2] for 'O'"
      print "Entry: "
      choice = gets.chomp.to_i
      if choice == 1
        @player1['symbol'] = ("X")
        @player2['symbol'] = ("O")
        @who_is_x = 'player1'
      elsif choice == 2
        @player1['symbol'] = ("O")
        @player2['symbol'] = ("X")
        @who_is_x = 'player2'
      else
        puts
        puts "#{choice} is not a valid option. Please try again:"
        # sleep(2.5)
        # system "clear"
      end
    end
    puts
    puts "Great choice! #{@player1['name']}'s symbol is '#{@player1['symbol']}' and #{@player2['name']}'s is '#{@player2['symbol']}'"
    puts "[ANY KEY] to continue."
    gets.chomp
  end

  def who_goes_first
    system "clear"
    puts "Who goes first?"
    puts "[1] #{@player1['name']}"
    puts "[2] #{@player2['name']}"
    print "Entry: "
    choice = gets.chomp.to_i
    until @first_player
      if choice == 1
        @first_player = 'player1'
        puts "Great! #{@player1['name']} will go first."
      elsif choice == 2
        @first_player = 'player2'
        puts "Great! #{@player2['name']} will go first."
      else
        print "#{choice} is not a valid choice, please choose [1] or [2]: "
        choice = gets.chomp.to_i
      end
    end
    puts
    puts "[ANY KEY] to continue."
    gets.chomp
  end

  def start_game
    # start by printing the board
    system "clear"
    puts "#{@current_player['name']}, make your first move!"
    if (@game_type == 2 && @current_player['player_type'] == "Computer") || @game_type == 3
      puts "(#{@current_player['name']} is thinking...)"
    end
    # loop through until the game was won or tied
    if @game_type == 'hvh'
      human_vs_human
    elsif @game_type == 'hvc'
      human_vs_computer
    elsif @game_type == 'cvc'
      computer_vs_computer
    end
    end_of_game    
  end

  def print_board
    puts
    puts " #{@board["0"]} | #{@board["1"]} | #{@board["2"]} \n===+===+===\n #{@board["3"]} | #{@board["4"]} | #{@board["5"]} \n===+===+===\n #{@board["6"]} | #{@board["7"]} | #{@board["8"]} \n"
    puts
  end

  def human_vs_human
    until @game_is_over
      print_board
      get_human_spot
      @board = @game['board']
      unless @game['game_is_over']
        if @current_player == @player1
          puts "#{@player1['name']}'s turn."
        else
          puts "#{@player2['name']}'s turn."
        end
      end
    end
  end

  def get_human_spot
    @space = nil
    until @space
      puts "Enter [0-8] to choose a spot on the board:"
      @space = gets.chomp.to_i
      if @board[@space.to_s] == "X" || @board[@space.to_s] == "O" 
        puts "That spot is already taken, choose another spot."
        @space = nil
      elsif @space.between?(0, 8)
        params = {
          player: @current_player,
          space: @space
        }
        @game = Unirest.patch("http://localhost:3000/v1/games/#{@game['id']}", parameters: params).body
        @current_player = @game['next_player']
        puts "Current Player: #{@current_player}"
        @game_is_over = @game['game_is_over']
        system "clear"
        if @current_player
          puts "#{@current_player['name']} chose: #{@space} - the #{spots[@space]} space."
        end
      else
        print "That is not a valid spot, please try again: "
        @space = nil
      end
    end
  end

  def human_vs_computer
    print_board
    if @first_player == 'player2'
      puts "I took #{@game['computer_move']}, the #{spots[@game['computer_move']]} space."
      print_board
      unless @game['game_is_over']
        puts "Your turn, #{@current_player['name']}."
      end
    end
    until @game['game_is_over']
      if @current_player['player_type'] == "Human"
        get_human_spot
        if @game['game_is_over']
          break
          end_of_game
        end
        @board[@space.to_s] = @player1['symbol']
        print_board
        puts "Computer: #{@game['computer_response']}"
        # sleep(3)
        @board = @game['board']
        system "clear"
        puts "I took #{@game['computer_move']}, the #{spots[@game['computer_move']]} space."
        print_board
        unless @game['game_is_over']
          puts "Your turn, #{@current_player['name']}."
        end
      end
    end
  end

  def computer_vs_computer
    until game_is_over(@board) || tie(@board)
      eval_board
      unless game_is_over(@board) || tie(@board)
        print_board
        switch_player
        puts "#{@current_player['name']}'s turn."
        puts "[ANY KEY] to continue"
        gets.chomp
        system "clear"
      end
    end
  end

  def spots
    {
      0 => "top-left corner",
      1 => "top-middle",
      2 => "top-right corner",
      3 => "middle-left",
      4 => "center",
      5 => "middle-right",
      6 => "bottom-left corner",
      7 => "bottom-middle",
      8 => "bottom-right corner",
    }
  end

  def computer_move_description(spot)
    unless @game['game_is_over']
      puts "#{@current_player['name']}: I took the #{spots[spot]} spot.\n\n"
    end
  end

  def winning_message
    if @game['winner']
      "#{@game['winner']['name']} won! Great job #{@game['winner']['name']}, play again!"
    elsif @game['tie']
      "It was a tie! Play again!"
    end
      
  end

  def end_of_game
    system "clear"
    puts "*** GAME OVER ***"
    print_board
    if @game_type != 'hvh'
      puts "*** Computer: #{@game['computer_response']} ***\n\n"
    else
      puts "*** #{winning_message} ***\n\n"
    end
    puts "What would you like to do?"
    puts "[1] For a rematch"
    puts "[2] To start a new game"
    puts "[3] To quit"
    choice = gets.chomp.to_i
    if choice == 1
      re_match
    elsif choice == 2
      Game.new
    end
  end

  def re_match
    @board = Unirest.post("http://localhost:3000/v1/boards").body
    params = {
      game_type: @game_type,
      level: @difficulty_level,
      names: [@player1['name'], @player2['name']],
      who_is_x: @who_is_x,
      board_id: @board['id'],
      player1: @player1,
      player2: @player2
    }
    @game = Unirest.post("http://localhost:3000/v1/games", parameters: params).body
    @player1 = @game['player1']
    @player2 = @game['player2']
    @first_player == 'player1' ? @current_player = @player1 : @current_player = @player2
    @game_is_over = false
    start_game
  end

end

game = Game.new