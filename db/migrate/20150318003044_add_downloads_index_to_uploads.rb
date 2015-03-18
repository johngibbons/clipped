class AddDownloadsIndexToUploads < ActiveRecord::Migration
  def change
    add_index :uploads, :downloads
  end
end
