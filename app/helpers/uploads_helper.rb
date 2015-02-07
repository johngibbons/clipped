module UploadsHelper
  def like(upload)
    upload.likes += 1
  end
end
