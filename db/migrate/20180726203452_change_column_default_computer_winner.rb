class ChangeColumnDefaultComputerWinner < ActiveRecord::Migration[5.2]
  def change
    change_column_default :computers, :winner, false
  end
end
