class CreateUploadFromURL

  def initialize(direct_upload_url)
    @direct_upload_url = direct_upload_url
  end

  private

    def cloud_storage_service
      AWS::S3.new
    end

    def direct_upload_url_data
      %r{\/(?<path>uploads\/.+\/(?<filename>.+))\z}.match(@direct_upload_url)
    end

    def direct_upload_attributes
      tries ||= 5
      cloud_storage_service.buckets[ENV["AWS_BUCKET"]].objects[direct_upload_url_data[:path]].head
    rescue AWS::S3::Errors::NoSuchKey => e
      tries -= 1
      if tries > 0
        sleep(3)
        retry
      else
        false
      end
    end

    # Set attachment attributes from the direct upload
    # @note Retry logic handles S3 "eventual consistency" lag.
    def set_upload_attributes
      @upload.image_file_name     = direct_upload_url_data[:filename]
      @upload.image_file_size     = direct_upload_attributes.content_length
      @upload.image_content_type  = direct_upload_attributes.content_type
      @upload.image_updated_at    = direct_upload_attributes.last_modified
    end

end