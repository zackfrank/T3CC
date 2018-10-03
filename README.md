A Tic Tac Toe game with a Ruby on Rails backend that feeds two frontend interfaces:

A browser frontend using the Vue.js framework

-- and --

A console frontend using plain Ruby files to run

User/player can play in three main modes:
1. Human vs. Human
2. Human vs. Computer
3. Computer vs. Computer (more for user exhibition than user interaction aside from setting up the game)

In any mode involving Computer opponent(s), three levels of difficulty are available to choose from:
1. Easy - computer chooses random spots
2. Medium - computer uses some strategy with aim to win or block opponent from winning
3. Hard - computer plays very aggressively to win or block opponent from succeeding

Human users may enter names for themselves, choose symbols (X or O), and decide who makes the first move.

When game ends, user has option to rematch (new game with all same settings), or to start a completely
new game in any mode.

----------------------------------------------------------------------------------------------------------------
DATABASE:

Project requires postgres database (no seeding necessary).

In gemfile: 
gem 'pg', '>= 0.18', '< 2.0'

Be sure to run the following after cloning:
- [T3CC]$ rails db:create
- [T3CC]$ rails db:migrate

----------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------
TESTING:

Project contains rspec tests for public rails model methods. Ensure rspec enabled/included in gemfile:

group :development, :test do
  gem 'rspec-rails', '~> 3.7'
end

Be sure to kill the server (if running) and run the following command after adding the rspec gem:
- [T3CC]$ bundle install

To run tests for all models (ex.):
- [T3CC]$ bundle exec rspec spec/models

To run tests for individual models (ex. for Game model):
- [T3CC]$ bundle exec rspec spec/models/game_spec.rb

Project includes the following models:
- Game (game.rb), to test: game_spec.rb
- Board (board.rb), to test: board_spec.rb
- Computer (computer.rb), to test: computer_spec.rb
- Human (human.rb), to test: human_spec.rb
----------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------
EXECUTION:

To run the browser frontend:
- Run a rails server (ie. [T3CC]$ rails server), open a browser, navigate to appropriate local host (ie. localhost:3000/#/)
- If you're interested in seeing the app run live over the WAN - visit https://tic-tac-toe-zf.herokuapp.com/#/
   - Obviously this will not respond to local updates unless they are pushed to the heroku 
   repository which will require appropriate credentials for authentication

To run the console frontend: 
- Navigate to the project folder in your console and run file called 'run_console.rb':
 [T3CC]$ ruby run_console.rb
----------------------------------------------------------------------------------------------------------------


- Author: Zack Frank
- Email: frank.zack@gmail.com
- Linkedin: https://www.linkedin.com/in/zack-frank/
- Github: https://github.com/zackfrank/