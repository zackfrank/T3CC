class RemovePlayer1IdFromGames < ActiveRecord::Migration[5.2]
  def change
    remove_column :games, :player1_id, :integer
    remove_column :games, :player2_id, :integer
  end
end
