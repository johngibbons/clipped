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