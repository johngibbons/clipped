class AddBodyToComments < ActiveRecord::Migration
  def change
    add_column :comments, :comment_body, :text
  end
end
