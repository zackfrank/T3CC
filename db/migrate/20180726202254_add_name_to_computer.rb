class AddNameToComputer < ActiveRecord::Migration[5.2]
  def change
    add_column :computers, :name, :string
  end
end
