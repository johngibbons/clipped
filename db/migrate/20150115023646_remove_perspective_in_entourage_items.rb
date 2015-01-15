class RemovePerspectiveInEntourageItems < ActiveRecord::Migration
  def change
    remove_column :entourage_items, :perspective
  end
end
