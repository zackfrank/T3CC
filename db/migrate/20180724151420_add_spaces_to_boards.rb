class AddSpacesToBoards < ActiveRecord::Migration[5.2]
  def change
    add_column :boards, :spaces, :string
  end
end
