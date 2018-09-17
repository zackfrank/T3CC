class RemoveWinnerFromComputer < ActiveRecord::Migration[5.2]
  def change
    remove_column :computers, :winner, :boolean
  end
end
