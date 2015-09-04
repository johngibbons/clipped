class CommentPresenter < BasePresenter

  def commenter_avatar
    user = @model.commenter
    user.avatar.url(:profile)
  end

end
