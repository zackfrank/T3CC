class AddSymbolToComputer < ActiveRecord::Migration[5.2]
  def change
    add_column :computers, :symbol, :string
  end
end
