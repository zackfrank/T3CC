class AddWinnerToComputer < ActiveRecord::Migration[5.2]
  def change
    add_column :computers, :winner, :boolean
  end
end
