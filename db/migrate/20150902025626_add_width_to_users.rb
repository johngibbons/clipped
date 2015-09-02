class AddWidthToUsers < ActiveRecord::Migration
  def change
    add_column :users, :avatar_original_width, :integer, null: false, default: 0
  end
end
