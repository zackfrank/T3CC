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
      // player1Name: "",
      // player2Name: "",
      nameErrorMessage: null,
      names: false,
      first: false,
      // player1Symbol: "",
      // player2Symbol: "",
      start: false,
      computerResponse: "",
      message: "",
      currentPlayer: "",
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
          console.log(response.data);
          this.player1 = response.data.player1;
          this.player2 = response.data.player2;
          console.log("Player 1:", this.player1);
          console.log("Player 2:", this.player2);
        }.bind(this)
      );
    },
    chooseTopLeft: function() {
      this.topLeft = this.player1.symbol;
    },
    chooseTopCenter: function() {
      this.topCenter = this.player1.symbol;
    },
    chooseTopRight: function() {
      this.topRight = this.player1.symbol;
    },
    chooseMiddleLeft: function() {
      this.middleLeft = this.player1.symbol;
    },
    chooseCenter: function() {
      this.center = this.player1.symbol;
    },
    chooseMiddleRight: function() {
      this.middleRight = this.player1.symbol;
    },
    chooseBottomLeft: function() {
      this.bottomLeft = this.player1.symbol;
    },
    chooseBottomCenter: function() {
      this.bottomCenter = this.player1.symbol;
    },
    chooseBottomRight: function() {
      this.bottomRight = this.player1.symbol;
    },
    playAgain: function() {
      location.reload();
    }
    // chooseSpot: function(spot, desc, player) {
    //   console.log(desc, "spot has been selected.");
    //   if (player === this.currentPlayer) {
    //     this.board.spaces[0] = this.player1Symbol;
    //     console.log("Spaces:", this.board.spaces);
    //     this.topLeft = !this.desc;
    //     console.log(this.topLeft);
    //   }
    // }
    // chooseSpot(spot) {
    //   var board = this.board;
    //   board.spaces[spot] = 'X';
    //   console.log(board.spaces);
    //   var params = {
    //     spaces: board.spaces
    //   };
    //   axios.patch("v1/boards/" + board.id, params).then(
    //     function(response) {
    //       this.board = response.data;
    //       console.log(this.board);
    //     }.bind(this)
    //   );
    // }
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