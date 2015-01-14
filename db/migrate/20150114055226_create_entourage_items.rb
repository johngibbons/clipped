class CreateEntourageItems < ActiveRecord::Migration
  def change
    create_table :entourage_items do |t|
      t.attachment :image
      t.text :tags

      t.timestamps null: false
    end
  end
end
