class CreateUploads < ActiveRecord::Migration
  def change
    create_table :uploads do |t|
      t.string :image
      t.text :tags
      t.references :user, index: true
      t.integer :views
      t.integer :downloads

      t.timestamps null: false
    end
    add_foreign_key :uploads, :users
    add_index :uploads, :tags
    add_index :uploads, [:user_id, :created_at]
    add_index :uploads, [:views, :created_at]
    add_index :uploads, [:downloads, :created_at]
    add_index :uploads, :created_at
  end
end
