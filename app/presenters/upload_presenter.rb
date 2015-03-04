class UploadPresenter < BasePresenter

  def classes
    class_list = []
    approval_classes(class_list)
    processed_classes(class_list)
  end

  def src(size)
    if @model.processed?
      @model.image(size)
    else
      @model.direct_upload_url
    end
  end

  def tag_presenter
    if Pundit.policy!(current_user, @model)
      
    end
  end

  private

  def approval_classes(class_list)
    if @model.approved?
      class_list << "approved"
    else
      class_list << "unapproved"
    end
  end

  def processed_classes(class_list)
    if @model.processed?
      class_list << "processed"
    else
      class_list << "unprocessed"
    end
  end

end