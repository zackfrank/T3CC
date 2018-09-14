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
    axios.post("v1/boards").then(
      function(response) {
        this.board = response.data;
      }.bind(this)
    );
  },
  methods: {
    computerNames: function() {
      if (this.gameType === 'cvc') {
        this.player1.name = 'Computer 1';
        this.player2.name = 'Computer 2';
        this.namesSubmitted = true;
      }
    },
    submitNames: function() {
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
    startGame: function() {
      if (this.player1.symbol === 'X') {
        var whoIsX = 'player1';
      } else {
        whoIsX = 'player2';
      }
      var params = {
        game_type: this.gameType,
        level: this.difficultyLevel,
        names: [this.player1.name, this.player2.name],
        who_is_x: whoIsX,
        board_id: this.board.id
      };
      axios.post("v1/games", params).then(
        function(response) {
          this.start = true; // clear modal
          this.game = response.data;
          this.player1 = response.data.player1;
          this.player2 = response.data.player2;
          this.message = this.firstPlayerName + ", make your first move!";
          if (this.firstPlayerName === this.player1.name) {
            this.currentPlayer = response.data.player1;
            if (this.gameType === 'cvc') {
              this.cvcGameplay();
            }
          } else {
            this.currentPlayer = response.data.player2;
            if (this.gameType === 'hvc') {
              this.submitMove(null);
              this.currentPlayer = this.player1;
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
        this.spotTaken();
      }
    },
    chooseTopCenter: function() {
      if (this.topCenter === "" && this.moveAllowed) {
        this.topCenter = this.currentPlayer.symbol;
        this.submitMove(1);
      } else {
        this.spotTaken();
      }
    },
    chooseTopRight: function() {
      if (this.topRight === "" && this.moveAllowed) {
        this.topRight = this.currentPlayer.symbol;
        this.submitMove(2);
      } else {
        this.spotTaken();
      }
    },
    chooseMiddleLeft: function() {
      if (this.middleLeft === "" && this.moveAllowed) {
        this.middleLeft = this.currentPlayer.symbol;
        this.submitMove(3);
      } else {
        this.spotTaken();
      }
    },
    chooseCenter: function() {
      if (this.center === "" && this.moveAllowed) {
        this.center = this.currentPlayer.symbol;
        this.submitMove(4);
      } else {
        this.spotTaken();
      }
    },
    chooseMiddleRight: function() {
      if (this.middleRight === "" && this.moveAllowed) {
        this.middleRight = this.currentPlayer.symbol;
        this.submitMove(5);
      } else {
        this.spotTaken();
      }
    },
    chooseBottomLeft: function() {
      if (this.bottomLeft === "" && this.moveAllowed) {
        this.bottomLeft = this.currentPlayer.symbol;
        this.submitMove(6);
      } else {
        this.spotTaken();
      }
    },
    chooseBottomCenter: function() {
      if (this.bottomCenter === "" && this.moveAllowed) {
        this.bottomCenter = this.currentPlayer.symbol;
        this.submitMove(7);
      } else {
        this.spotTaken();
      }
    },
    chooseBottomRight: function() {
      if (this.bottomRight === "" && this.moveAllowed) {
        this.bottomRight = this.currentPlayer.symbol;
        this.submitMove(8);
      } else {
        this.spotTaken();
      }
    },
    spotTaken: function() {
      if (this.moveAllowed) {
        this.message = "That spot has already been taken, please choose a valid spot.";
      } else {
        this.message = "You cannot take that spot because it is not your turn.";
      }
    },
    submitMove: function(space) {
      this.moveAllowed = false;

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
      setTimeout(function() {
        this.makeComputerMove(this.player2.symbol, game.computer_move);
        this.moveAllowed = true;
        this.currentPlayer = game.next_player;
      }.bind(this), 1500);
      this.checkForAndProcessGameOver();
      this.printMessage();
    },
    printMessage: function() {
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
      if (this.gameType === 'hvc' && (this.game.winner.id === this.game.player2.id || (this.game.tie && this.firstPlayerName === this.player2.name))) {
        return true;
      }
    },
    cvcGameplay: function() {
      this.moveAllowed = false;

      let params = {
        player: this.currentPlayer,
      };

      axios.patch("v1/games/" + this.game.id, params).then(
        function(response) {
          console.log("Computer move: ", response.data.computer_move);
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