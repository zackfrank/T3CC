class Add1ToBoards < ActiveRecord::Migration[5.2]
  def change
    add_column :boards, "1", :string
    add_column :boards, "2", :string
    add_column :boards, "3", :string
    add_column :boards, "4", :string
    add_column :boards, "5", :string
    add_column :boards, "6", :string
    add_column :boards, "7", :string
    add_column :boards, "8", :string
  end
end
