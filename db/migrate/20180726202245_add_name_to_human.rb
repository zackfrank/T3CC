class AddNameToHuman < ActiveRecord::Migration[5.2]
  def change
    add_column :humen, :name, :string
  end
end
