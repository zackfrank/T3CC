/* global Vue, VueRouter, axios */

var HomePage = {
  template: "#home-page",
  data: function() {
    return {
      game: {},
      board: {},
      gameType: null,
      difficultyLevel: null,
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
    /* Create a board on the backend, load corresponding numbers into each board space (ie board[1] === 1)
    Load board into frontend */
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
    setPlayer1Symbol: function(symbol) {
      // Sets player1 symbol from Symbol modal on frontend
      this.player1.symbol = symbol;
    },
    startGame: function() {
      /* Sends all game and player data to backend to set up game and start game
      If computer makes first move, 
       */
      // if (this.player1.symbol === 'X') {
      //   var whoIsX = 'player1';
      // } else {
      //   whoIsX = 'player2';
      // }
      var params = {
        game_type: this.gameType,
        level: this.difficultyLevel,
        names: [this.player1.name, this.player2.name],
        // who_is_x: whoIsX,
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

          /* If player1 starts, set current player to player1 and start hvh/hvc, or cvc gameplay
          Once human move is sumbitted, submitMove() will sort out whether to proceed to next
          human move or to process a computer move based on game type */
          if (this.firstPlayerName === this.player1.name) {
            this.currentPlayer = response.data.player1;
            if (this.gameType === 'cvc') {
              this.cvcGameplay();
            }
          // If player2 starts...
          } else {
            // Set current player to player2 and start hvh gameplay or the following...
            this.currentPlayer = response.data.player2;
            if (this.gameType === 'hvc') {
              
              // Computer starts hvc game - move is made on back end, then switch to human user
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
      /* Submits human moves during hvh and hvc gameplay via patch request to /games/[:id] endpoint

      hvh gameplay: processes move (see processHumanVsHumanMove()), and prints a message (see printMessage()) 
      hvc gameplay: prints 'Computer's Turn', processes moves (see processHUmanVsComputerMove())*/


      this.moveAllowed = false; // to bar a player from taking a second turn before the next player goes

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
          this.board = response.data.board;
          this.game = response.data;

          if (this.gameType === 'hvh') {
            this.processHumanVsHumanMove(response.data);
            this.printMessage();
          } else if (this.gameType === 'hvc') {
            this.message = this.player2.name + "'s turn!";
            this.processHumanVsComputerMove(response.data);
          } 

        }.bind(this)
      );
    },
    processHumanVsHumanMove: function(game) {
      this.currentPlayer = game.next_player;
      this.checkForAndProcessGameOver();
      this.moveAllowed = true;
    },
    processHumanVsComputerMove: function(game) {
      this.computerResponse = "Computer: " + game.computer_response;

      // Computer move is delayed to add element of realism to gameplay (as if computer is thinking)
      setTimeout(function() {
        this.makeComputerMove(this.player2.symbol, game.computer_move);
        this.currentPlayer = game.next_player;
        this.moveAllowed = true;
      }.bind(this), 1500);

      this.checkForAndProcessGameOver();
      this.printMessage();
    },
    printMessage: function() {
      
      /* This function prints whose turn it is after a turn is taken during hvh 
      or hvc gameplay unless game is over, then it prints 'Game Over!'

      In human vs. human games, messages can be delivered immediately,
      however when playing against a computer, messages are delayed 1.5 sec
      to line up with delay in computer move - computer moves are delayed to
      make gameplay seem more realistic */

      if (this.game.winner || this.game.tie) {
        if (this.computerEndsHvcGame()) {
          setTimeout(function() {
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
      /* this.winner and this.tie will trigger frontend message and modal if truthy- 
      so they are delayed if computer makes final move, otherwise user would 
      be notified game is over before computer move was made visible to human user */

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
      /* Conditions to know computer ended HVC game:
      
      Game type is 'hvc'
      -- and --
      
      Either winner is Computer which is player2 
      -- or --
      Game is tied and Computer made the first move 
      (which would mean Computer also made last move) */

      if (this.gameType === 'hvc' && (this.game.winner.id === this.game.player2.id || (this.game.tie && this.firstPlayerName === this.player2.name))) {
        return true;
      }
    },
    cvcGameplay: function() {
      this.moveAllowed = false; // bars user from clicking on a spot and 'making a move'

      var params = {
        player: this.currentPlayer,
      };

      axios.patch("v1/games/" + this.game.id, params).then(
        function(response) {
          this.board = response.data.board;
          this.game = response.data;
          setTimeout(function() {
            this.makeComputerMove(this.currentPlayer.symbol, response.data.computer_move);
            this.currentPlayer = response.data.next_player;
            this.computerResponse = this.currentPlayer.name + ": " + response.data.computer_response;
            if (response.data.winner || response.data.tie) {
              this.message = "Game Over!";
            } else {
              this.message = this.currentPlayer.name + "'s turn!";
            }
            if (!response.data.winner && !response.data.tie) {
              this.cvcGameplay();
            }
            this.checkForAndProcessGameOver();
          }.bind(this), 1500);
        }.bind(this)
      );
    },
    makeComputerMove: function(symbol, spot) {
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
  },
  computed: {}
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