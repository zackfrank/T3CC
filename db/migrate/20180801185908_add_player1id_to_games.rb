class AddPlayer1idToGames < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :player1_id, :integer
    add_column :games, :player2_id, :integer
  end
end
