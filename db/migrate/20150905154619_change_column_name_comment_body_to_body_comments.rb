class ChangeColumnNameCommentBodyToBodyComments < ActiveRecord::Migration
  def change
    rename_column :comments, :comment_body, :body
  end
end
