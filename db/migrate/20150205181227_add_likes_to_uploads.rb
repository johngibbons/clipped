class AddLikesToUploads < ActiveRecord::Migration
  def change
    add_column :uploads, :likes, :integer
  end
end
