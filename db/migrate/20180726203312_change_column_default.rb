class ChangeColumnDefault < ActiveRecord::Migration[5.2]
  def change
    change_column_default :humen, :winner, false
  end
end
