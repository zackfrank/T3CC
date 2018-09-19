require 'unirest'

class Console

  def initialize
    @board = Unirest.post("http://localhost:3000/v1/boards").body
    set_up
  end

  def animation
    def animation_frame1
      system "clear"
      puts "+- - - - - - - - - - - - - - - - - - - - - - - - - - - +"
      puts "                                                        "
      puts "|  Welcome to Tic Tac Toe by Command Line Games, Inc!  |"
      puts "                                                        "
      puts "+- - - - - - - - - - - - - - - - - - - - - - - - - - - +"
      sleep(0.3)
    end
    def animation_frame2
      system "clear"
      puts "+ - - - - - - - - - - - - - - - - - - - - - - - - - - -+"
      puts "|                                                      |"
      puts "   Welcome to Tic Tac Toe by Command Line Games, Inc!   "
      puts "|                                                      |"
      puts "+ - - - - - - - - - - - - - - - - - - - - - - - - - - -+"
      sleep(0.3)
    end
    def animation_sequence
      animation_frame1
      animation_frame2
    end
    animation_sequence
    animation_sequence
    animation_sequence
    animation_sequence
    animation_sequence
    animation_sequence
    animation_sequence
    animation_sequence
    display_banner
    sleep(0.5)
    puts
  end

  def display_banner
    system "clear"
    puts "+------------------------------------------------------+"
    puts "|                                                      |"
    puts "|  Welcome to Tic Tac Toe by Command Line Games, Inc!  |"
    puts "|                                                      |"
    puts "+------------------------------------------------------+"
    puts
  end

  def set_up
    animation
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
    puts "Are you ready?!\n\n"
    sleep(1.5)
    puts "Let's play!\n\n"
    sleep(1)
    print "."
    sleep(0.3)
    print "."
    sleep(0.3)
    print "."
    sleep(0.5)
    self.start_game
  end

  def player_setup
    display_banner
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
    puts "[Enter] to continue."
    gets.chomp
  end

  def difficulty_level
    display_banner
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
    puts "[Enter] to continue."
    gets.chomp
    system "clear"
  end

  def name_players
    display_banner
    def enter_p1_name
      print "Player 1, please enter your name: "
      name = gets.chomp
      until name != ""
        print "Please enter at least one alphanumeric character as your name: "
        name = gets.chomp
      end
      @player1['name'] = name
    end

    if @game_type == 'hvh'
      enter_p1_name
      puts
      print "Please enter a name for Player 2: "
      name = gets.chomp
      until name != ""
        print "Please enter at least one alphanumeric character to name Player 2: "
        name = gets.chomp
      end
      @player2['name'] = name
    elsif @game_type == 'hvc'
      enter_p1_name
      @player2['name'] = "Computer"
    elsif @game_type == 'cvc'
      @player1['name'] = "Computer 1"
      @player2['name'] = "Computer 2"
    end
  end

  def choose_symbol
    display_banner
    print "Please choose the symbol for #{@player1['name']}..."
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
      end
    end
    puts
    puts "Great choice! #{@player1['name']}'s symbol is '#{@player1['symbol']}' and #{@player2['name']}'s is '#{@player2['symbol']}'"
    puts "[Enter] to continue."
    gets.chomp
  end

  def who_goes_first
    display_banner
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
    puts "[Enter] to continue."
    gets.chomp
  end

  def start_game
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
    eight_spaces = " " * 8
    puts
    puts " #{eight_spaces}#{@board["0"]} | #{@board["1"]} | #{@board["2"]} \n#{eight_spaces}===+===+===\n #{eight_spaces}#{@board["3"]} | #{@board["4"]} | #{@board["5"]} \n#{eight_spaces}===+===+===\n #{eight_spaces}#{@board["6"]} | #{@board["7"]} | #{@board["8"]} \n"
    puts
  end

  def human_vs_human
    display_banner
    puts "#{@current_player['name']}, make your first move!"
    print_board
    get_human_spot

    until @game_is_over
      display_banner
      pre_board_display
      update_board
      print_board
      get_human_spot
    end
  end

  def pre_board_display
    if @game_type == 'hvh'
      if @game['next_player']
        puts "#{@current_player['name']} chose: #{@space} - the #{spots[@space]} space."
        update_current_player
      end
      unless @game['game_is_over']
        puts
        puts " " * 8 + "#{@current_player['name']}'s turn!"
      end
    elsif @game_type == 'hvc'
      puts "#{@player1['name']} chose: #{@space} - the #{spots[@space]} space."
      puts " " * 8 + "Computer's turn!"
    end
  end

  def update_board
    @board = @game['board']
  end

  def update_current_player
    @current_player = @game['next_player']
  end

  def get_human_spot
    @space = nil
    until @space
      puts "Enter [0-8] to choose a spot on the board:"
      @space = gets.chomp

      if user_input_is_valid
        if space_is_not_taken
          @space = @space.to_i
          params = {
            player: @current_player,
            space: @space
          }
          @game = Unirest.patch("http://localhost:3000/v1/games/#{@game['id']}", parameters: params).body
          @game_is_over = @game['game_is_over']
        else
          puts "That spot is already taken, choose another spot."
          @space = nil
        end
      else
        print "That is not a valid spot, please try again: "
        @space = nil
      end
    end

    if @game_type == "hvc"
      @board[@space.to_s] = @player1['symbol']
    end

  end

  def user_input_is_valid
    @space.to_i.to_s == @space && @space.to_i.between?(0, 8)
  end

  def space_is_not_taken
    @board[@space] != "X" && @board[@space] != "O"
  end

  def human_vs_computer
    @hvc_game_over = false
    hvc_first_move

    while true
      display_banner
      pre_board_display
      print_board
      hvc_make_computer_move
      if @game['winner'] == @player2 || @game['tie']
        break
        update_board
        end_of_game
      end
      get_human_spot
      if @game['winner'] == @player1 || @game['tie']
        break
        end_of_game
      end
    end
  end

  def hvc_first_move
    if @first_player == 'player2'
      hvc_computer_makes_first_move
      get_human_spot
    else
      display_banner
      puts "#{@player1['name']}, make your first move!"
      print_board
      get_human_spot
    end
  end

  # def is_hvc_game_over?(last_move)
  #   if @game['tie']
  #     @hvc_game_over = true
  #   else
  #     if last_move == "Human" && @game_is_over && @game['winner'] == @player1
  #       @hvc_game_over = true
  #     elsif last_move == "Computer" && @game_is_over && @game['winner'] == @player2
  #       @hvc_game_over = true
  #     end
  #   end
  # end

  def hvc_computer_makes_first_move
    params = {
        player: @player2,
      }
    @game = Unirest.patch("http://localhost:3000/v1/games/#{@game['id']}", parameters: params).body
    
    update_current_player
    display_banner
    puts "Computer, make your first move!"
    print_board

    hvc_make_computer_move
  end

  def hvc_make_computer_move
    if @game['game_is_over']
      puts "Computer: Looks like this game's about to end..."
    else
      puts "Computer: #{@game['computer_response']}"
    end
    puts "[Enter] to make computer move"
    gets.chomp

    display_banner
    puts "Computer: I took #{@game['computer_move']}, the #{spots[@game['computer_move']]} space."
    update_board
    @space = @game['computer_move']
    print_board

    unless @game['game_is_over']
      puts "Your turn, #{@player1['name']}."
    end
  end

  def computer_vs_computer
    until @game['game_is_over']

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
    end_game_display
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
      Console.new
    end
  end

  def end_game_display
    system "clear"
    if @game['winner']
      if @game['winner']['symbol'] == 'X'
        puts "+------------------------------------------------------+"
        puts "| X                                                  X |"
        puts "|                  *** GAME OVER ***                   |"
        puts "| X                                                  X |"
        puts "+------------------------------------------------------+"
      elsif @game['winner']['symbol'] == 'O'
        puts "+------------------------------------------------------+"
        puts "| O                                                  O |"
        puts "|                  *** GAME OVER ***                   |"
        puts "| O                                                  O |"
        puts "+------------------------------------------------------+"
      end
    else
      puts "+------------------------------------------------------+"
      puts "| X                                                  O |"
      puts "|                  *** GAME OVER ***                   |"
      puts "| O                                                  X |"
      puts "+------------------------------------------------------+"
    end
    @board = @game['board']
    if @game['winner']
      puts "#{@game['winner']['name']} took the #{spots[@space]} spot to win!"
    else
      puts " " * 9 + "Tie game!"
    end
    print_board
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