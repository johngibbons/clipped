class AddNotNullAndDefaultToPerspective < ActiveRecord::Migration
  def change
    change_column :uploads, :perspective, :integer, default: 0, null: false
  end
end
