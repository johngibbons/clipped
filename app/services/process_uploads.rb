class ProcessUploads

  # Final upload processing step
  def transfer_and_cleanup(id)
    upload = Upload.find(id)
          
    upload.image = URI.parse(URI.escape(upload.direct_upload_url))
    upload.processed = true

    upload.save!
    
    s3.buckets[ENV["AWS_BUCKET"]].objects[direct_upload_url_data[:path]].delete
  end

      # Queue file processing
  def queue_processing
    Upload.delay.transfer_and_cleanup(id)
  end
end