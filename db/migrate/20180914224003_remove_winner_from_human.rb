class RemoveWinnerFromHuman < ActiveRecord::Migration[5.2]
  def change
    remove_column :humen, :winner, :boolean
  end
end
