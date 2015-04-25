class ChangeLikesToFavorites < ActiveRecord::Migration
  def change
    rename_column :relationships, :liker_id, :favoriter_id
    rename_column :relationships, :liked_id, :favorited_id
    rename_column :uploads, :likes_count, :favorites_count
  end
end
