class AddCategoriesToUploads < ActiveRecord::Migration
  def change
    add_column :uploads, :category, :integer, index: true, default: 0, null: false
  end
end
