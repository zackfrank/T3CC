class Add0ToBoards < ActiveRecord::Migration[5.2]
  def change
    add_column :boards, "0", :string
  end
end
