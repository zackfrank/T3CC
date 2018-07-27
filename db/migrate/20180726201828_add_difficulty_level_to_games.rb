class AddDifficultyLevelToGames < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :difficulty_level, :string
  end
end
