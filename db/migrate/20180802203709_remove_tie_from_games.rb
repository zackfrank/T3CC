class RemoveTieFromGames < ActiveRecord::Migration[5.2]
  def change
    remove_column :games, :tie, :boolean
  end
end
