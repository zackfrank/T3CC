class AddGameIdToComputers < ActiveRecord::Migration[5.2]
  def change
    add_column :computers, :game_id, :integer
  end
end
