# config/initializers/aws.rb
require 'aws-sdk'

# S3.new will now use the credentials specified in AWS.config
AWS.config( logger:            Rails.logger,
            access_key_id:     ENV['S3_ACCESS_KEY'],
            secret_access_key: ENV['S3_SECRET_KEY'],
            bucket:            ENV['S3_BUCKET'] )

Rails.configuration.aws = AWS::S3.new