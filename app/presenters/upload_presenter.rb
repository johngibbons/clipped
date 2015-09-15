class UploadPresenter < BasePresenter

  def processed_class
    if @model.processed?
      "processed"
    else
      "unprocessed"
    end
  end

  def approval_class
    if @model.approved?
      "approved"
    else
      "unapproved"
    end
  end

  def tagged_class
    unless @model.tags.size > 0
      " no-tags"
    end
  end

  def current_tags
    if @model.tags.size > 0
      h.content_tag(:div, class: "tags-thumb") do
        h.render @model.tags
      end
    else
      h.content_tag(:div, class: "tags-thumb") do
        h.content_tag(:p, "no tags yet, please add some to be considered for approval", class: "warning")
      end
    end
  end

  def src(size)
    if @model.processed?
      @model.image(size)
    else
      @model.dz_thumb
    end
  end

  def tag_presenter
    if Pundit.policy!(current_user, @model)
      
    end
  end

  def clipper_avatar
    user = @model.user
    user.avatar.url(:profile)
  end

end
