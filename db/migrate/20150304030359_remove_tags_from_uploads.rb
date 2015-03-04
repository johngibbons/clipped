class RemoveTagsFromUploads < ActiveRecord::Migration
  def change
    remove_column :uploads, :tags
  end
end
