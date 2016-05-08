class CommentsMailer < ApplicationMailer
  def new_comment_email(commenter, comment, upload)
    @commenter = commenter
    @comment = comment
    @upload = upload
    @uploader = @upload.user
    mail(to: @uploader.email, subject: 'New Clipped Comment On Your Upload')
  end

  def new_reply_email(commenter, comment, upload, parent)
    @commenter = commenter
    @comment = comment
    @upload = upload
    @parent = parent

    mail(to: @parent.commenter.email, subject: 'New Reply to Your Comment')
  end
end
