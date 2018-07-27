class AddPlayer2IdToGames < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :player2_id, :integer
  end
end
