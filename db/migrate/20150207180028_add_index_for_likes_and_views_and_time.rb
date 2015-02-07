class AddIndexForLikesAndViewsAndTime < ActiveRecord::Migration
  def change
    add_index :uploads, :likes_count
    add_index :uploads, [:likes_count, :created_at, :views, :downloads], name: 'weighted_score'
  end
end
