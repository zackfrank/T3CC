class AddBoardIdToGames < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :board_id, :integer
  end
end
