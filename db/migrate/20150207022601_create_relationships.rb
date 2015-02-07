class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.integer :liked_id
      t.integer :liker_id

      t.timestamps null: false
    end
    add_index :relationships, :liker_id
    add_index :relationships, :liked_id
    add_index :relationships, [:liker_id, :liked_id], unique: true
  end
end
