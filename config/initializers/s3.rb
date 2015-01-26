# initializers/s3.rb
if Rails.env == "production"
  # set credentials from ENV hash
  S3_CREDENTIALS = { :access_key_id => ENV['S3_ACCESS_KEY'], :secret_access_key => ENV['S3_SECRET_KEY'], :bucket => "entourageapp"}
else
  # get credentials from YML file
  S3_CREDENTIALS = Rails.root.join("config/s3.yml")
end

AWS.config(access_key_id:     ENV['S3_ACCESS_KEY'],
           secret_access_key: ENV['S3_SECRET_KEY'] )

S3_BUCKET = AWS::S3.new.buckets[ENV['S3_BUCKET']]