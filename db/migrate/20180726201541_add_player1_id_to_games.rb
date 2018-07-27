class AddPlayer1IdToGames < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :player1_id, :integer
  end
end
