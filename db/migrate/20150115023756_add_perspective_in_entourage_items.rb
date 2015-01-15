class AddPerspectiveInEntourageItems < ActiveRecord::Migration
  def change
    add_column :entourage_items, :perspective, :integer
  end
end
