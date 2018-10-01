/* global Vue, VueRouter, axios */

var HomePage = {
  template: "#home-page",
  data: function() {
    return {
      game: {},
      board: {},
      gameType: null,
      difficultyLevel: null,
      symbols: null,
      player1: {
        name: "",
        symbol: ""
      },
      player2: {
        name: "",
        symbol: ""
      },
      currentPlayer: {},
      nameErrorMessage: null,
      namesSubmitted: false,
      firstPlayerName: null,
      start: false,
      computerResponse: "",
      message: "",
      topLeft: "",
      topCenter: "",
      topRight: "",
      middleLeft: "",
      center: "",
      middleRight: "",
      bottomLeft: "",
      bottomCenter: "",
      bottomRight: "",
      moveAllowed: true,
      winner: null,
      tie: false
    };
  },
  created: function() {
    /* 
    Create a board on the backend
    Load corresponding numbers into each board space (ie board[1] === 1)
    Load board into frontend
    */
    axios.post("v1/boards").then(
      function(response) {
        this.board = response.data;
      }.bind(this)
    );
  },
  methods: {
    playerSetup: function() {
      /* Create players on backend based on game type:

      hvh creates two human players
      hvc creates a human and a computer player
      cvc creates two computer players 
      
      Load players to frontend as player1 and player2:
      player1 will always be the human player in hvh and hvc --- only computer in cvc
      player2 will always be computer player in hvc and cvc --- only human in hvh

      If cvc, adds names "Computer 1" and "Computer 2" to player1 and player2 respectively
      and sets namesSubmitted variable to true so name submission modal does not pop up
      */
      if (this.gameType === 'hvh') {
        axios.post("v1/humen").then(
          function(response) {
            this.player1 = response.data;
          }.bind(this)
        );
        axios.post("v1/humen").then(
          function(response) {
            this.player2 = response.data;
          }.bind(this)
        );
      } else if (this.gameType === 'hvc') {
        axios.post("v1/humen").then(
          function(response) {
            this.player1 = response.data;
          }.bind(this)
        );
        axios.post("v1/computers").then(
          function(response) {
            this.player2 = response.data;
          }.bind(this)
        );       
      } else if (this.gameType === 'cvc') {
        this.namesSubmitted = true;
        axios.post("v1/computers").then(
          function(response) {
            this.player1 = response.data;
            this.player1.name = "Computer 1";
          }.bind(this)
        );
        axios.post("v1/computers").then(
          function(response) {
            this.player2 = response.data;
            this.player2.name = "Computer 2";
          }.bind(this)
        );
      }
    },
    showDifficultyLevelModal: function() {
      // returns boolean to either show or not show difficulty level modal at the correct time
      return this.gameType !== 'hvh' && this.gameType && !this.difficultyLevel;
    },
    showNamesModal: function() {
      // returns boolean to show names modal at the correct time
      return (this.gameType === 'hvh' || (this.gameType === 'hvc' && this.difficultyLevel)) && !this.namesSubmitted;
    },
    showSymbolsModal: function() {
      return (this.gameType && this.difficultyLevel && this.namesSubmitted && !this.symbols) || (this.gameType === 'cvc' && this.difficultyLevel && !this.symbols) || (this.gameType === 'hvh' && this.namesSubmitted && !this.symbols);
    },
    showWhoGoesFirstModal: function() {
      return this.namesSubmitted && this.player1.name && !this.firstPlayerName && this.symbols;
    },
    showStartGameModal: function() {
      if (this.firstPlayerName && !this.start) {
        return true;
      } else {
        return false;
      }
    },
    submitNames: function() {
      /* For games involving human players (hvh & hvc):
      If names are properly submitted, 
      sets namesSubmitted variable to true to clear names modal from screen.
      For hvc game, player2 is named "Computer" on frontend */
      if (this.gameType === 'hvh') {
        if (this.player1.name && this.player2.name) {
          this.namesSubmitted = true;
        } else {
          this.nameErrorMessage = "Please enter a name for each player.";
        }
      } else if (this.gameType === 'hvc') {
        if (this.player1.name) { 
          this.player2.name = 'Computer';
          this.namesSubmitted = true;
        } else {
          this.nameErrorMessage = "Please enter a name.";
        }
      }
    },
    setSymbols: function(symbol) {
      // Sets respsective player symbols from Symbol modal on frontend
      if (symbol === "X") {
        this.symbols = ["X", "O"];
      } else {
        this.symbols = ["O", "X"];
      }
    },
    startGame: function() {
      /* Sends all game and player data to backend to set up game and start game
      Data is then updated on front end

      If computer makes first move, move is retrieved from backend
      If human makes first move, appropriate player is encouraged to choose a spot 

      If game type is cvc, cvcGameplay() is called to run cvc game
       */
      var params = {
        game_type: this.gameType,
        level: this.difficultyLevel,
        names: [this.player1.name, this.player2.name],
        symbols: this.symbols,
        board_id: this.board.id,
        player1: this.player1,
        player2: this.player2
      };
      axios.post("v1/games", params).then(
        function(response) {
          this.start = true; // clear modal
          this.game = response.data;

          // Update players with game_id, symbols, names
          this.player1 = response.data.player1;
          this.player2 = response.data.player2;

          // Send message to first player to make the first move
          this.message = this.firstPlayerName + ", make your first move!";

          // If player1 starts:
          if (this.firstPlayerName === this.player1.name) {
            
            // Set current player to player 1, human player1 is free to make the first move
            this.currentPlayer = response.data.player1;
            
            // If game type is cvc, jump right into cvc gameplay with player1 starting
            if (this.gameType === 'cvc') {
              this.cvcGameplay();
            }
          // If player2 starts:
          } else {
            // Set current player to player2
            // If game type is hvh, human player2 is free to make the first move
            this.currentPlayer = response.data.player2;
            if (this.gameType === 'hvc') {
              
              /* If game type is hvc:
              Computer starts game - move is made on backend then registered on frontend
              Then switch current player to human user, player1 */
              this.submitMove(null);
              this.currentPlayer = this.player1;

              // If game type is cvc, jump right into cvc gameplay with player2 starting
            } else if (this.gameType === 'cvc') {
              this.cvcGameplay();
            }
          }
        }.bind(this)
      );
    },
    /* ---------------------------------------------------------------------------------------------
    The following nine functions register human moves for each of the nine possible 
    spots on the tic tac toe board.

    If the spot is available and a move is allowed (ie. it is a human's turn), the choice will 
    be submitted to the backend to process via submitMove()

    If the spot is taken or it is the computer's turn, spotErrorMessage() is called to deliver
    the appropriate error message to the user
    --------------------------------------------------------------------------------------------- */
    chooseTopLeft: function() {
      if (this.topLeft === "" && this.moveAllowed) {
        this.topLeft = this.currentPlayer.symbol;
        this.submitMove(0);
      } else {
        this.spotErrorMessage();
      }
    },
    chooseTopCenter: function() {
      if (this.topCenter === "" && this.moveAllowed) {
        this.topCenter = this.currentPlayer.symbol;
        this.submitMove(1);
      } else {
        this.spotErrorMessage();
      }
    },
    chooseTopRight: function() {
      if (this.topRight === "" && this.moveAllowed) {
        this.topRight = this.currentPlayer.symbol;
        this.submitMove(2);
      } else {
        this.spotErrorMessage();
      }
    },
    chooseMiddleLeft: function() {
      if (this.middleLeft === "" && this.moveAllowed) {
        this.middleLeft = this.currentPlayer.symbol;
        this.submitMove(3);
      } else {
        this.spotErrorMessage();
      }
    },
    chooseCenter: function() {
      if (this.center === "" && this.moveAllowed) {
        this.center = this.currentPlayer.symbol;
        this.submitMove(4);
      } else {
        this.spotErrorMessage();
      }
    },
    chooseMiddleRight: function() {
      if (this.middleRight === "" && this.moveAllowed) {
        this.middleRight = this.currentPlayer.symbol;
        this.submitMove(5);
      } else {
        this.spotErrorMessage();
      }
    },
    chooseBottomLeft: function() {
      if (this.bottomLeft === "" && this.moveAllowed) {
        this.bottomLeft = this.currentPlayer.symbol;
        this.submitMove(6);
      } else {
        this.spotErrorMessage();
      }
    },
    chooseBottomCenter: function() {
      if (this.bottomCenter === "" && this.moveAllowed) {
        this.bottomCenter = this.currentPlayer.symbol;
        this.submitMove(7);
      } else {
        this.spotErrorMessage();
      }
    },
    chooseBottomRight: function() {
      if (this.bottomRight === "" && this.moveAllowed) {
        this.bottomRight = this.currentPlayer.symbol;
        this.submitMove(8);
      } else {
        this.spotErrorMessage();
      }
    },
    spotErrorMessage: function() {
      if (this.moveAllowed) {
        this.message = "That spot has already been taken, please choose a valid spot.";
      } else {
        this.message = "You cannot take that spot because it is not your turn.";
      }
    },
    submitMove: function(space) {
      /* 

      Submits human moves during hvh and hvc gameplay to backend for processing

      hvh gameplay: processes move (see processHumanVsHumanMove()), and prints a message (see printMessage()) 
      hvc gameplay: prints "Computer's Turn", processes moves (see processHumanVsComputerMove()) 

      */


      this.moveAllowed = false; // this bar a player from taking a second turn before the next player goes

      // ----------- To account for minimax processing time ------------
      if (this.difficultyLevel === "Hard") {
        this.message = this.player2.name + "'s turn!";
        this.computerResponse = "Computer: Hmmm... let me think.";
      }
      // ---------------------------------------------------------------

      var params = {
        player: this.currentPlayer,
        space: space
      };

      axios.patch("v1/games/" + this.game.id, params).then(
        function(response) {
          var game = response.data;
          this.board = game.board;
          this.game = game;

          if (this.gameType === 'hvh') {
            this.processHumanVsHumanMove(game);
            this.printMessage();
          } else if (this.gameType === 'hvc') {
            this.message = this.player2.name + "'s turn!";
            this.processHumanVsComputerMove(game);
          } 

        }.bind(this)
      );
    },
    processHumanVsHumanMove: function(game) {
      this.currentPlayer = game.next_player; // updates current player
      this.checkForAndProcessGameOver(); // checks for a win or tie after every move
      this.moveAllowed = true; // allows move to be made since current player has been updated
    },
    processHumanVsComputerMove: function(game) {
      // Human-like response from computer player is delivered to frontend
      this.computerResponse = "Computer: " + game.computer_response;

      // Computer move is delayed to add element of realism to gameplay (as if computer is thinking)
      setTimeout(function() {
        this.displayComputerMove(this.player2.symbol, game.computer_move); // makes appropriate symbol visible on frontend
        this.currentPlayer = game.next_player; // update current player
        this.moveAllowed = true; // allow human move now that current player has been updated
      }.bind(this), 1500);

      this.checkForAndProcessGameOver(); // Check for win or tie after every move
      this.printMessage(); // Prints appropriate message after every move
    },
    printMessage: function() {
      /* 

      This function prints whose turn it is after a turn is taken during hvh 
      or hvc gameplay unless game is over, then it prints 'Game Over!'

      In human vs. human games, messages are delivered immediately,
      however when playing against a computer, messages are delayed 1.5 sec
      to line up with delay in computer move which are delayed to
      make gameplay seem more realistic 

      */

      if (this.game.winner || this.game.tie) {
        if (this.computerEndsHvcGame()) {
          setTimeout(function() {
            /* Game Over msg is delayed slightly more so user can see 
            computer make the move just before modal pops up */
            this.message = "Game Over!";
          }.bind(this), 1600);
        } else {
          this.message = "Game Over!";
        }
      } else {
        if (this.gameType === 'hvh') {
          this.message = this.currentPlayer.name + "'s turn!";
        } else {
          setTimeout(function() {
            this.message = this.currentPlayer.name + "'s turn!";
          }.bind(this), 1500);
        }
      }
    },
    checkForAndProcessGameOver: function() {
      /* 

      Updates 'winner' and 'tie' which are tied to game over modal.
      They will trigger modal if truthy.

      The update is delayed if computer makes final move, otherwise user would 
      be notified game is over before computer move was made visible to human user.

      */

      if (this.computerEndsHvcGame()) {
        setTimeout(function() {
          this.winner = this.game.winner;
          this.tie = this.game.tie;          
        }.bind(this), 1600);
      } else {
        this.winner = this.game.winner;
        this.tie = this.game.tie;
      }
    },
    computerEndsHvcGame: function() {
      /* 
      
      This returns a boolean for whether player2 ('Computer') ends hvc game.

      Conditions to know computer ended HVC game:
      
      Game type is 'hvc'

      -- and --
      
      Either winner is 'Computer' which is player2 
      -- or --
      Game is tied and 'Computer' made the first move 
      (which would mean 'Computer' also made last move) 

      */

      if (this.gameType === 'hvc' && (this.game.winner.id === this.game.player2.id || (this.game.tie && this.firstPlayerName === this.player2.name))) {
        return true;
      }
    },
    cvcGameplay: function() {
      /* 
      Runs recursively until there is a winner or a tie.
      Depending on difficulty level, backend processes computer move and sends to front.
      Each move is delayed 1.5 seconds to give computers a slightly realistic/human feel
      */

      this.moveAllowed = false; // bars human user from clicking on a spot and 'making a move'

      axios.patch("v1/games/" + this.game.id, {player: this.currentPlayer}).then(
        function(response) {
          var game = response.data;
          this.board = game.board;
          this.game = game;
          setTimeout(function() {
            this.displayComputerMove(this.currentPlayer.symbol, game.computer_move); // show computer move
            this.currentPlayer = game.next_player; // update current player
            this.computerResponse = this.currentPlayer.name + ": " + game.computer_response; // show computer response

            // Print appropriate message after each turn
            if (game.winner || game.tie) {
              this.message = "Game Over!";
            } else {
              this.message = this.currentPlayer.name + "'s turn!";
            }

            // If game is not over, process next turn (this is where recursion occurs)
            if (!game.winner && !game.tie) {
              this.cvcGameplay();
            }

            // Process game over after recursion ends
            this.checkForAndProcessGameOver();
          }.bind(this), 1500);
        }.bind(this)
      );
    },
    displayComputerMove: function(symbol, spot) {
      // Updates frontend to show computer's symbol in spot computer has 'chosen'
      if (spot === 0) {
        this.topLeft = symbol;
      } else if (spot === 1) {
        this.topCenter = symbol;
      } else if (spot === 2) {
        this.topRight = symbol;
      } else if (spot === 3) {
        this.middleLeft = symbol;
      } else if (spot === 4) {
        this.center = symbol;
      } else if (spot === 5) {
        this.middleRight = symbol;
      } else if (spot === 6) {
        this.bottomLeft = symbol;
      } else if (spot === 7) {
        this.bottomCenter = symbol;
      } else if (spot === 8) {
        this.bottomRight = symbol;
      }
    },
    rematch: function() {
      // Reset the board for a rematch with same settings as the previous game
      this.topLeft = "";
      this.topCenter = "";
      this.topRight = "";
      this.middleLeft = "";
      this.center = "";
      this.middleRight = "";
      this.bottomLeft = "";
      this.bottomCenter = "";
      this.bottomRight = ""; 
      this.computerResponse = "";
      this.moveAllowed = true;
      this.winner = null;
      this.tie = false;
      axios.post("v1/boards").then(
        function(response) {
          this.board = response.data;
          this.startGame();
        }.bind(this)
      );
    },
    startOver: function() {
      // start a completely new game by reloading the site/app
      location.reload();
    }
  }
};

var router = new VueRouter({
  routes: [{ path: "/", component: HomePage }],
  scrollBehavior: function(to, from, savedPosition) {
    return { x: 0, y: 0 };
  }
});

var app = new Vue({
  el: "#vue-app",
  router: router
});