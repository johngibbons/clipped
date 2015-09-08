class CommentPresenter < BasePresenter

  def commenter_avatar
    user = @model.commenter
    user.avatar.url(:profile)
  end

  def reply_name
    if @model.parent_id
      h.content_tag(:i, "", class: "fa fa-retweet") +
      h.content_tag(:span, Comment.find(@model.parent_id).commenter.username, class: "reply-name").html_safe
    end
  end

  def comments_feed(comments)
    if comments.size > 0
      comments_tree_for(comments)
    else
      comments_placeholder
    end
  end

  def comments_placeholder
    if !u.email.blank?
      h.content_tag(:p, "No comments yet.  Be the first to add one.", class: "comments-placeholder")
    else
      h.content_tag(:p) do
        "Please #{h.link_to('login', h.login_path)} to comment.".html_safe
      end
    end
  end

  private

    def comments_tree_for(comments)
      comments.map do |comment, nested_comments|
        h.render(comment) +
          (nested_comments.size > 0 ? h.content_tag(:div, comments_tree_for(nested_comments), class: "replies") : nil)
      end.join.html_safe
    end

end
