class ProcessUploads

  def initialize(upload)
    @upload = upload
    @id = upload.id
    @direct_upload_url = upload.direct_upload_url
  end

  # Queue file processing
  def queue_processing
    handle_asynchronously(transfer_and_cleanup(@upload))
  end

  private

    def cloud_storage_service
      AWS::S3.new
    end

    def direct_upload_url_data
      %r{\/(?<path>uploads\/.+\/(?<filename>.+))\z}.match(@direct_upload_url)
    end

    # Final upload processing step
    def transfer_and_cleanup(upload)
            
      upload.image = URI.parse(URI.escape(@direct_upload_url))
      upload.processed = true

      upload.save!
      
      cloud_storage_service.buckets[ENV["AWS_BUCKET"]].objects[direct_upload_url_data[:path]].delete
    end
end