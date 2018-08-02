class AddTopLeftToBoards < ActiveRecord::Migration[5.2]
  def change
    add_column :boards, :top_left, :string
    add_column :boards, :top_center, :string
    add_column :boards, :top_right, :string
    add_column :boards, :middle_left, :string
    add_column :boards, :center, :string
    add_column :boards, :middle_right, :string
    add_column :boards, :bottom_left, :string
    add_column :boards, :bottom_center, :string
    add_column :boards, :bottom_right, :string
  end
end
