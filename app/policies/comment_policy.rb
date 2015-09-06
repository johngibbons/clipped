class CommentPolicy < ApplicationPolicy

  attr_reader :user, :comment

  def initialize(user, comment)
    @user = user
    @comment = comment
  end

  def create?
    logged_in?
  end

  def destroy?
    admin_or_logged_in_and_own?
  end

  private

  def admin_or_logged_in_and_own?
    @user.admin? || logged_in? && @user == @comment.commenter
  end

end
