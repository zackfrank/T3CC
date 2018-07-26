/* global Vue, VueRouter, axios */

var HomePage = {
  template: "#home-page",
  data: function() {
    return {
      gameType: null,
      difficultyLevel: null,
      player1Name: "",
      player2Name: "",
      names: false,
      board: { spaces: [] },
      player1Symbol: "X",
      player2Symbol: "",
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
      bottomRight: ""
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
    namesToggle: function() {
      // add more logic in case names aren't entered
      if (this.player1Name) { 
        this.names = true;
      }
    },
    chooseTopLeft: function() {
      this.topLeft = this.player1Symbol;
    },
    chooseTopCenter: function() {
      this.topCenter = this.player1Symbol;
    },
    chooseTopRight: function() {
      this.topRight = this.player1Symbol;
    },
    chooseMiddleLeft: function() {
      this.middleLeft = this.player1Symbol;
    },
    chooseCenter: function() {
      this.center = this.player1Symbol;
    },
    chooseMiddleRight: function() {
      this.middleRight = this.player1Symbol;
    },
    chooseBottomLeft: function() {
      this.bottomLeft = this.player1Symbol;
    },
    chooseBottomCenter: function() {
      this.bottomCenter = this.player1Symbol;
    },
    chooseBottomRight: function() {
      this.bottomRight = this.player1Symbol;
    },
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