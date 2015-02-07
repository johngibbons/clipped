class AddDefaultValueOfZeroToViewsDownloadsLikesInUploads < ActiveRecord::Migration
  def self.up
    change_column :uploads, :views, :integer, :default => 0
    change_column :uploads, :downloads, :integer, :default => 0
    change_column :uploads, :likes, :integer, :default => 0
  end

  def self.down
  end
end
