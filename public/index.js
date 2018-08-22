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
      names: false,
      first: false,
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
      moveAllowed: true
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
        this.names = true;
      }
    },
    submitNames: function() {
      if (this.gameType === 'hvh') {
        if (this.player1.name && this.player2.name) {
          this.names = true;
        } else {
          this.nameErrorMessage = "Please enter a name for each player.";
        }
      } else if (this.gameType === 'hvc') {
        if (this.player1.name) { 
          this.player2.name = 'Computer';
          this.names = true;
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
          this.message = this.first + ", make your first move!";
          if (this.first === this.player1.name) {
            this.currentPlayer = this.player1;
          } else {
            this.currentPlayer = this.player2;
            if (this.gameType === 'hvc') {
              this.submitMove(null);
              this.currentPlayer = this.player1;
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
      var params = {
        player: this.currentPlayer,
        space: space
      };
      axios.patch("v1/games/" + this.game.id, params).then(
        function(response) {
          this.board = response.data.board;

          // If hvc, we have a computer move returned after every submitted human move
          if (this.gameType === 'hvc' && (response.data.winner.id !== this.player1.id) && ((response.data.tie && (this.first === this.player2.name)) || !response.data.tie)) {
            // Human move not allowed while computer is 'thinking'
            this.moveAllowed = false;
            // Stall computer move for 1.5sec to make it more 'realistic'
            setTimeout(function() {
              this.registerComputerMove();
            }.bind(this), 1500);
          }

          // If last move is made by computer, stall ending the game to correspond
          if (((response.data.winner.id === this.player2.id) || (response.data.tie && (this.first === this.player2.name))) && !this.moveAllowed) {
            console.log("Computer won or tied.");
            console.log("response.data.winner: ", response.data.winner);
            console.log("this.player2: ", this.player2);
            console.log("response.data.tie: ", response.data.tie);
            console.log("this.first: ", this.first);
            console.log("this.player2.name: ", this.player2.name);
            console.log("this.moveAllowed: ", this.moveAllowed);
            setTimeout(function() {
              this.game = response.data;
              this.message = "Game over!";
              this.computerResponse = "Computer: " + this.game.computer_response;
            }.bind(this), 1500);
          } else {
            this.game = response.data;
            if (response.data.winner || response.data.tie) {
              // End game if game's over
              this.message = "Game Over!";
              this.computerResponse = "Computer: " + this.game.computer_response;
            } else {
              // Switch player messaging if game continues (maybe separate out messaging function)
              if (this.game.game_type === 'hvh') { 
                this.message = this.currentPlayer.name + "'s turn!";
              } else {
                this.message = "Computer's Turn";
                this.computerResponse = "Computer: " + this.game.computer_response;
              }
            }
          }
        }.bind(this)
      );
    },
    registerComputerMove: function() {
      if (this.board[0] === this.player2.symbol && this.topLeft === "") {
        this.topLeft = this.player2.symbol;
      } else if (this.board[1] === this.player2.symbol && this.topCenter === "") {
        this.topCenter = this.player2.symbol;
      } else if (this.board[2] === this.player2.symbol && this.topRight === "") {
        this.topRight = this.player2.symbol;
      } else if (this.board[3] === this.player2.symbol && this.middleLeft === "") {
        this.middleLeft = this.player2.symbol;
      } else if (this.board[4] === this.player2.symbol && this.center === "") {
        this.center = this.player2.symbol;
      } else if (this.board[5] === this.player2.symbol && this.middleRight === "") {
        this.middleRight = this.player2.symbol;
      } else if (this.board[6] === this.player2.symbol && this.bottomLeft === "") {
        this.bottomLeft = this.player2.symbol;
      } else if (this.board[7] === this.player2.symbol && this.bottomCenter === "") {
        this.bottomCenter = this.player2.symbol;
      } else if (this.board[8] === this.player2.symbol && this.bottomRight === "") {
        this.bottomRight = this.player2.symbol;
      }
      this.moveAllowed = true;
      this.message = this.currentPlayer.name + "'s turn!";
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
      this.currentPlayer = this.first;
      this.computerResponse = "";
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