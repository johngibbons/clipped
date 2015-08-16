class ProcessUploads

  include ServiceHelper
  include Virtus.model

  attribute :upload, Upload

  # Queue file processing
  def call
    transfer_and_cleanup(@upload)
  end

  private

    def cloud_storage_service
      AWS::S3.new
    end

    def direct_upload_url_data
      %r{\/(?<path>uploads\/.+\/(?<filename>.+))\z}.match(@upload.direct_upload_url)
    end

    # Final upload processing step
    def transfer_and_cleanup(upload)
            
      upload.image = URI.parse(URI.escape(@upload.direct_upload_url))
      upload.processed = true

      upload.save!
      
      cloud_storage_service.buckets[ENV["AWS_BUCKET"]].objects[direct_upload_url_data[:path]].delete
    end
    handle_asynchronously :transfer_and_cleanup, :queue => 'image_processing'
end
