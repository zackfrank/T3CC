class AddSymbolToHuman < ActiveRecord::Migration[5.2]
  def change
    add_column :humen, :symbol, :string
  end
end
