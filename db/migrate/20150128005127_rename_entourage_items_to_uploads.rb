class RenameEntourageItemsToUploads < ActiveRecord::Migration
  def change
    rename_table :entourage_items, :uploads
  end
end
