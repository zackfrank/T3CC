class AddGameIdToHumen < ActiveRecord::Migration[5.2]
  def change
    add_column :humen, :game_id, :integer
  end
end
