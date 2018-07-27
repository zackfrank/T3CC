class AddWinnerToHuman < ActiveRecord::Migration[5.2]
  def change
    add_column :humen, :winner, :boolean
  end
end
