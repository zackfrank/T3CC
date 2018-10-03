require 'unirest'

class Console
  private

    def initialize
      @board = Unirest.post("http://localhost:3000/v1/boards").body
      set_up
    end

    def opening_animation
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
      # opening_animation
      player_and_game_type_setup
      if @game_type != "hvh"
        set_difficulty_level
      end
      name_players
      choose_symbol
      who_goes_first
      params = {
        game_type: @game_type,
        level: @difficulty_level,
        names: [@player1['name'], @player2['name']],
        symbols: @symbols,
        board_id: @board['id'],
        player1: @player1,
        player2: @player2
      }
      @game = Unirest.post("http://localhost:3000/v1/games", parameters: params).body

      @player1 = @game['player1']
      @player2 = @game['player2']
      @first_player == 'player1' ? @current_player = @player1 : @current_player = @player2
      game_start_message
      start_game
    end

    def game_start_message
      display_banner
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
    end

    def player_and_game_type_setup
      game_types = [
        "[1] Human vs. Human",
        "[2] Human vs. Computer",
        "[3] Computer vs. Computer"
      ]
      until @player1 do
        display_banner
        puts "Please choose a game type:"
        puts "#{game_types[0]}"
        puts "#{game_types[1]}"
        puts "#{game_types[2]}"
        print "Entry: "
        entry = gets.chomp.to_i
        if entry == 1
          @player1 = Unirest.post("http://localhost:3000/v1/humen").body
          @player2 = Unirest.post("http://localhost:3000/v1/humen").body
          @game_type = 'hvh'
        elsif entry == 2
          @player1 = Unirest.post("http://localhost:3000/v1/humen").body
          @player2 = Unirest.post("http://localhost:3000/v1/computers").body
          @game_type = 'hvc'
        elsif entry == 3
          @player1 = Unirest.post("http://localhost:3000/v1/computers").body
          @player2 = Unirest.post("http://localhost:3000/v1/computers").body
          @game_type = 'cvc'
        else
          puts
          puts "You entered an invalid entry. [Enter] to try again."
          gets.chomp
        end
      end
      puts
      puts "Great! You chose #{game_types[entry-1]}."
      puts "[Enter] to continue."
      gets.chomp
    end

    def set_difficulty_level
      until @difficulty_level do
        display_banner
        puts "Please choose a difficulty level:"
        puts "[1] Easy"
        puts "[2] Medium"
        puts "[3] Hard"
        print "Entry: "
        entry = gets.chomp.to_i
        if entry == 1
          @difficulty_level = "Easy"
        elsif entry == 2
          @difficulty_level = "Medium"
        elsif entry == 3
          @difficulty_level = "Hard"
        else
          puts
          puts "You entered an invalid entry. [Enter] to try again."
          gets.chomp
        end
      end
      puts
      puts "Great! You chose '#{@difficulty_level}'."
      puts "[Enter] to continue."
      gets.chomp
    end

    def name_players
      display_banner

      if @game_type == 'hvh'
        enter_p1_name
        puts
        print "Please enter a name for Player 2: "
        name = gets.chomp
        until name != ""
          puts
          puts "Please enter at least one alphanumeric character to name Player 2: "
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

    def enter_p1_name
      print "Player 1, please enter your name: "
      name = gets.chomp
      until name != ""
        puts
        puts "Please enter at least one alphanumeric character as your name: "
        name = gets.chomp
      end
      @player1['name'] = name
    end

    def choose_symbol
      @symbols = []
      until @symbols[0]
        display_banner
        print "Please choose the symbol for #{@player1['name']}..."
        puts
        puts "[1] for 'X'"
        puts "[2] for 'O'"
        print "Entry: "
        entry = gets.chomp.to_i
        if entry == 1
          @symbols = ["X", "O"]
        elsif entry == 2
          @symbols = ["O", "X"]
        else
          puts
          puts "You entered an invalid entry. [Enter] to try again."
          gets.chomp
        end
      end
      puts
      puts "Great choice! #{@player1['name']}'s symbol is '#{@symbols[0]}' and #{@player2['name']}'s is '#{@symbols[1]}'."
      puts "[Enter] to continue."
      gets.chomp
    end

    def who_goes_first
      until @first_player
        display_banner
        puts "Who goes first?"
        puts "[1] #{@player1['name']}"
        puts "[2] #{@player2['name']}"
        print "Entry: "
        entry = gets.chomp.to_i
        if entry == 1
          @first_player = 'player1'
          puts
          puts "Great! #{@player1['name']} will go first."
        elsif entry == 2
          @first_player = 'player2'
          puts
          puts "Great! #{@player2['name']} will go first."
        else
          puts
          puts "You entered an invalid entry. [Enter] to try again."
          gets.chomp
        end
      end
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

      until @game['game_is_over']
        display_banner
        display_spot_taken_and_whose_turn
        update_board
        print_board
        get_human_spot
      end
      end_of_game
    end

    def display_spot_taken_and_whose_turn
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
      elsif @game_type == 'cvc'
        puts "#{@previous_player['name']}: I took #{@space}, the #{spots[@space]} space."
        unless @game['game_is_over']
          puts "Your turn, #{@current_player['name']}."
        end
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
            
            if @game_type == 'hvc'
              @board[@space.to_s] = @current_player['symbol']
              computer_thinking
            end

            @game = Unirest.patch("http://localhost:3000/v1/games/#{@game['id']}", parameters: params).body
          else
            puts "That spot is already taken, choose another spot."
            @space = nil
          end
        else
          puts "That is not a valid spot, please try again."
          @space = nil
        end
      end

    end

    def user_input_is_valid
      @space.to_i.to_s == @space && @space.to_i.between?(0, 8)
    end

    def space_is_not_taken
      @board[@space] != "X" && @board[@space] != "O"
    end

    def human_vs_computer
      hvc_first_move

      while true
        display_banner
        display_spot_taken_and_whose_turn
        print_board
        hvc_make_computer_move
        if @game['winner'] == @player2 || @game['tie']
          update_board
          end_of_game
          break
        end
        get_human_spot
        if @game['winner'] == @player1 || (@game['tie'] && @game['computer_move'] === nil)
          # if after user move is submitted in patch request there is a tie, it could be from
          # either human or computer move - if no computer move was made then human ended game
          end_of_game
          break
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
      # This allows user to decide when to view computer move, rather than computer move 
      # appearing after a hard-coded amount of time.

      print_computer_response

      display_banner
      puts "Computer: I took #{@game['computer_move']}, the #{spots[@game['computer_move']]} space."
      update_board
      @space = @game['computer_move']
      print_board

      unless @game['game_is_over']
        puts "Your turn, #{@player1['name']}."
      end
    end

    def computer_thinking
      # Creates a separate thread so that while patch request is processing, this function can
      # run concurrently to show animation that prints: "Computer is thinking..."
      # This way user doesn't feel that the program has froze if patch requests takes a long time, 
      # ie while minimax is processing on the backend.
      game = @game.dup
      
      Thread.new {
        def sleep_and_print_unless_computer_is_ready(game, time, text)
          sleep(time)
          unless game != @game
            print text
          end
        end

        if @game_type == 'hvc'
          name = "Computer"
        elsif @game_type == 'cvc'
          name = @current_player['name']
        end

        until game != @game # until patch request is complete after computer move has been processed
          display_banner
          display_spot_taken_and_whose_turn
          print_board
          sleep_and_print_unless_computer_is_ready(game, 0, "#{name} is thinking")
          sleep_and_print_unless_computer_is_ready(game, 1, ".")
          sleep_and_print_unless_computer_is_ready(game, 0.3, ".")
          sleep_and_print_unless_computer_is_ready(game, 0.3, ".")
          sleep_and_print_unless_computer_is_ready(game, 0.3, "")
        end
      }
    end

    def computer_vs_computer
      cvc_first_move
      @cvc_round = 1
      # @cvc_round is used in cvc_make_computer_move to determine when delay will occur due to minimax
      # on round 3 on Hard level (which takes additional time to process), computer_thinking() is called
      # First two moves of minimax (hard computer move processing on backend) are hard-coded to expedite,
      # but beyond first two moves, the rest are processed and the third move takes the most time

      until @game['game_is_over']
        @cvc_round += 1
        display_banner
        display_spot_taken_and_whose_turn
        print_board
        cvc_make_computer_move
        print_computer_response
      end
      end_of_game
    end

    def cvc_first_move
      display_banner
      puts "#{@current_player['name']}, make your first move!"
      print_board
      
      @game = Unirest.patch("http://localhost:3000/v1/games/#{@game['id']}", parameters: {player: @current_player}).body
      update_board
      
      print_computer_response
      puts "[Enter] to view computer move"
      gets.chomp
      @space = @game['computer_move']
      @previous_player = @current_player.dup
      update_current_player
    end

    def print_computer_response
      # Response depends on whether or not game is about to end.
      # Computer name depends on game type.

      if @game['game_is_over']
        if @game_type == 'hvc'
          print "Computer: "
        elsif @game_type == 'cvc'
          print "#{@next_player['name']}: "
        end
        print "Looks like this game's about to end...\n"
      else
        if @game_type == 'hvc'
          print "Computer: "
        elsif @game_type == 'cvc'
          print "#{@next_player['name']}: "
        end
        print "#{@game['computer_response']}\n"
      end
      puts "[Enter] to view computer move"
      gets.chomp
    end

    def cvc_make_computer_move
      if @difficulty_level == 'Hard' && @cvc_round == 3
        computer_thinking
      end

      @game = Unirest.patch("http://localhost:3000/v1/games/#{@game['id']}", parameters: {player: @current_player}).body
      update_board

      @space = @game['computer_move']
      @previous_player = @current_player.dup
      @next_player = @current_player.dup
      update_current_player
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
      if @game_type == 'hvh'
        puts "*** #{winning_message} ***\n\n"
      elsif @game_type == 'hvc'
        puts "*** Computer: #{@game['computer_response']} ***\n\n"
      elsif @game_type == 'cvc'
        puts "*** #{@current_player['name']}: #{@game['computer_response']} ***\n\n"
      end
      puts "What would you like to do?"
      puts "[1] For a rematch"
      puts "[2] To start a new game"
      puts "[Enter] To quit"
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
        board_id: @board['id'],
        symbols: @symbols,
        player1: @player1,
        player2: @player2
      }
      @game = Unirest.post("http://localhost:3000/v1/games", parameters: params).body
      @player1 = @game['player1']
      @player2 = @game['player2']
      @first_player == 'player1' ? @current_player = @player1 : @current_player = @player2
      start_game
    end

end