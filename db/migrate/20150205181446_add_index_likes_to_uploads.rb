class AddIndexLikesToUploads < ActiveRecord::Migration
  def change
    add_index :uploads, :likes
  end
end
