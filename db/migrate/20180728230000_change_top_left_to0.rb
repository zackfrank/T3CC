class ChangeTopLeftTo0 < ActiveRecord::Migration[5.2]
  def change
    remove_column :boards, :top_left, :string
    remove_column :boards, :top_center, :string
    remove_column :boards, :top_right, :string
    remove_column :boards, :middle_left, :string
    remove_column :boards, :center, :string
    remove_column :boards, :middle_right, :string
    remove_column :boards, :bottom_left, :string
    remove_column :boards, :bottom_center, :string
    remove_column :boards, :bottom_right, :string
  end
end
