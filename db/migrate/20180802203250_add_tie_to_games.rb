class AddTieToGames < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :tie, :boolean
  end
end
