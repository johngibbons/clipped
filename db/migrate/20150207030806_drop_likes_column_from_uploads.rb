class DropLikesColumnFromUploads < ActiveRecord::Migration
  def change
    remove_column :uploads, :likes
  end
end
