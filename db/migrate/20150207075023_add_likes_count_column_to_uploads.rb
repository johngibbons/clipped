class AddLikesCountColumnToUploads < ActiveRecord::Migration
  def change
    add_column :uploads, :likes_count, :integer, default: 0
  end
end
