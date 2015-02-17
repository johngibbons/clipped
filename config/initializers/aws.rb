# config/initializers/aws.rb
require 'aws-sdk'

# S3.new will now use the credentials specified in AWS.config
AWS.config( logger:            Rails.logger,
            access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
            secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
            bucket:            ENV['AWS_BUCKET'] )

Rails.configuration.aws = AWS::S3.new