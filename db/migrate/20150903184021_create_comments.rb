class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :body
      t.references :commenter, index: true, foreign_key: true
      t.references :commentee, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
  def change
    create_table :comments do |t|
      t.integer :commenter_id
      t.integer :commentee_id

      t.timestamps null: false
    end
    add_index :comments, :commenter_id
    add_index :comments, :commentee_id
    add_index :comments, [:commenter_id, :commentee_id]
  end
end
