/* global Vue, VueRouter, axios */

var HomePage = {
  template: "#home-page",
  data: function() {
    return {
      board: { spaces: [] },
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
      winner: null,
    };
  },
  created: function() {
    axios.post("v1/boards").then(
      function(response) {
        this.board = response.data;
        console.log(this.board);
        console.log("topLeft:", this.topLeft);
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
      // set player symbols (redundant with backend methods?)
      if (this.player1.symbol === 'X') {
        // this.player2.symbol = 'O';
        var whoIsX = 'player1';
      } else {
        // this.player2.symbol = 'X';
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
          this.start = true;
          this.player1 = response.data.player1;
          this.player2 = response.data.player2;
          this.message = this.first + ", make your first move!";
          if (this.first === this.player1.name) {
            this.currentPlayer = this.player1;
          } else {
            this.currentPlayer = this.player2;
          }
        }.bind(this)
      );
    },
    chooseTopLeft: function() {
      if (this.topLeft === "") {
        this.topLeft = this.currentPlayer.symbol;
        this.nextPlayer();
        this.message = this.currentPlayer.name + "'s turn!";
      } else {
        this.message = "That spot has already been taken, please choose a valid spot.";
      }
    },
    chooseTopCenter: function() {
      if (this.topCenter === "") {
        this.topCenter = this.currentPlayer.symbol;
        this.nextPlayer();
        this.message = this.currentPlayer.name + "'s turn!";
      } else {
        this.message = "That spot has already been taken, please choose a valid spot.";
      }
    },
    chooseTopRight: function() {
      if (this.topRight === "") {
        this.topRight = this.currentPlayer.symbol;
        this.nextPlayer();
        this.message = this.currentPlayer.name + "'s turn!";
      } else {
        this.message = "That spot has already been taken, please choose a valid spot.";
      }
    },
    chooseMiddleLeft: function() {
      if (this.middleLeft === "") {
        this.middleLeft = this.currentPlayer.symbol;
        this.nextPlayer();
        this.message = this.currentPlayer.name + "'s turn!";
      } else {
        this.message = "That spot has already been taken, please choose a valid spot.";
      }
    },
    chooseCenter: function() {
      if (this.center === "") {
        this.center = this.currentPlayer.symbol;
        this.nextPlayer();
        this.message = this.currentPlayer.name + "'s turn!";
      } else {
        this.message = "That spot has already been taken, please choose a valid spot.";
      }
    },
    chooseMiddleRight: function() {
      if (this.middleRight === "") {
        this.middleRight = this.currentPlayer.symbol;
        this.nextPlayer();
        this.message = this.currentPlayer.name + "'s turn!";
      } else {
        this.message = "That spot has already been taken, please choose a valid spot.";
      }
    },
    chooseBottomLeft: function() {
      if (this.bottomLeft === "") {
        this.bottomLeft = this.currentPlayer.symbol;
        this.nextPlayer();
        this.message = this.currentPlayer.name + "'s turn!";
      } else {
        this.message = "That spot has already been taken, please choose a valid spot.";
      }
    },
    chooseBottomCenter: function() {
      if (this.bottomCenter === "") {
        this.bottomCenter = this.currentPlayer.symbol;
        this.nextPlayer();
        this.message = this.currentPlayer.name + "'s turn!";
      } else {
        this.message = "That spot has already been taken, please choose a valid spot.";
      }
    },
    chooseBottomRight: function() {
      if (this.bottomRight === "") {
        this.bottomRight = this.currentPlayer.symbol;
        this.nextPlayer();
        this.message = this.currentPlayer.name + "'s turn!";
      } else {
        this.message = "That spot has already been taken, please choose a valid spot.";
      }
    },
    nextPlayer: function() {
      if (this.currentPlayer === this.player1) {
        this.currentPlayer = this.player2;
        return this.currentPlayer;
      } else {
        this.currentPlayer = this.player1;
        return this.currentPlayer;
      }
    },
    playAgain: function() {
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