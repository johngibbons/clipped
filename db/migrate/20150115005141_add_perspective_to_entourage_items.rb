class AddPerspectiveToEntourageItems < ActiveRecord::Migration
  def change
    add_column :entourage_items, :perspective, :string
  end
end
