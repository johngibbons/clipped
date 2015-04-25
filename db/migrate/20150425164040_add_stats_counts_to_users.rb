class AddStatsCountsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :favorites_count, :integer, null: false, default: 0, index: true
    add_column :users, :downloads_count, :integer, null: false, default: 0, index: true
    add_column :users, :views_count, :integer, null: false, default: 0, index: true
  end
end
