class Upload < ActiveRecord::Base
  belongs_to :user
  has_many :liked_relationships, class_name:  "Relationship",
                                 foreign_key: "liked_id",
                                 dependent:   :destroy
  has_many :likers, through: :liked_relationships
  default_scope -> { order(created_at: :desc) }

  # Environment-specific direct upload url verifier screens for malicious posted upload locations.
  # DIRECT_UPLOAD_URL_FORMAT = %r{\Ahttps:\/\/s3\.amazonaws\.com\/myapp#{!Rails.env.production? ? "\\-#{Rails.env}" : ''}\/(?<path>uploads\/.+\/(?<filename>.+))\z}.freeze
  
  validates :user_id, presence: true
  validates :direct_upload_url, presence: true

  before_create :set_upload_attributes
  after_create :queue_processing

  # Store an unescaped version of the escaped URL that Amazon returns from direct upload.
  def direct_upload_url=(escaped_url)
    write_attribute(:direct_upload_url, (CGI.unescape(escaped_url) rescue nil))
  end



  has_attached_file :image, 
                    styles: { original: "4000x4000>", large: "1500x1500>", medium: "750x750>", thumb: "x300>" },
                    :storage => :s3,
                    :s3_credentials => Proc.new{|a| a.instance.s3_credentials },
                    :s3_protocol => 'https',
                    :s3_host_name => "s3-us-west-2.amazonaws.com" 

  validates_attachment  :image,
                        :file_name => { :matches => /\.(gif|jpg|jpeg|tiff|png)$/i },
                        :size => { :less_than => 50.megabytes }

  def s3_credentials
    { :bucket => ENV['AWS_BUCKET'], 
      :access_key_id => ENV['AWS_ACCESS_KEY_ID'], 
      :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'] }
  end

  def weighted_score
      total_views = Upload.sum(views).to_f
      total_downloads = Upload.sum(downloads).to_f
      total_likes = Upload.sum(likes_count).to_f

      views_percent     = views/total_views
      downloads_percent = downloads/total_downloads
      likes_percent     = likes_count/total_likes

      if total_views == 0
        views_percent = 0
      end

      if total_downloads == 0
        downloads_percent = 0
      end

      if total_likes == 0
        likes_percent = 0
      end

      score = BigDecimal(0.2 * (views_percent) * 100 + 0.5 * (downloads_percent) * 100 + 0.3 * (likes_percent) * 100, 10)

  end

  class << self

    # Final upload processing step
    def transfer_and_cleanup(id)
      upload = Upload.find(id)
      direct_upload_url_data = %r{\/(?<path>uploads\/.+\/(?<filename>.+))\z}.match(upload.direct_upload_url)
      s3 = AWS::S3.new

      puts URI.parse(URI.escape(upload.direct_upload_url))
      
      upload.image = URI.parse(URI.escape(upload.direct_upload_url))
      upload.processed = true

      upload.save!
      
      s3.buckets[ENV["AWS_BUCKET"]].objects[direct_upload_url_data[:path]].delete
    end

    def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

    def sorted_by(attribute)
      Upload.all.reorder("#{attribute} DESC")
    end

    def sorted_by_weighted_score
      Upload.all.sort_by(&:weighted_score).reverse!
    end

  end

  protected
  
    # Set attachment attributes from the direct upload
    # @note Retry logic handles S3 "eventual consistency" lag.
    def set_upload_attributes
      tries ||= 5
      direct_upload_url_data = %r{\/(?<path>uploads\/.+\/(?<filename>.+))\z}.match(direct_upload_url)
      s3 = AWS::S3.new

      direct_upload_head = s3.buckets[ENV["AWS_BUCKET"]].objects[direct_upload_url_data[:path]].head
   
      self.image_file_name     = direct_upload_url_data[:filename]
      self.image_file_size     = direct_upload_head.content_length
      self.image_content_type  = direct_upload_head.content_type
      self.image_updated_at    = direct_upload_head.last_modified

    rescue AWS::S3::Errors::NoSuchKey => e
      tries -= 1
      if tries > 0
        sleep(3)
        retry
      else
        false
      end
    end
    
    # Queue file processing
    def queue_processing
      Upload.delay.transfer_and_cleanup(id)
    end

end
