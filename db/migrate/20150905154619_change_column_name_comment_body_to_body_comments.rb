class ChangeColumnNameCommentBodyToBodyComments < ActiveRecord::Migration
  def change
    rename_columm :comments, :comment_body, :body
  end
end
