class RemoveSpacesFromBoards < ActiveRecord::Migration[5.2]
  def change
    remove_column :boards, :spaces, :string
  end
end
