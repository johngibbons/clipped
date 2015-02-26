class Upload < ActiveRecord::Base
  belongs_to :user
  has_many :liked_relationships, class_name:  "Relationship",
                                 foreign_key: "liked_id",
                                 dependent:   :destroy
  has_many :likers, through: :liked_relationships
  default_scope -> { order(created_at: :desc) }

  attr_accessor :image_file_name, :image_updated_at, :image_content_type, :image_file_size
  
  validates :user_id, presence: true

  has_attached_file :image, 
                    styles: { original: "4000x4000>", large: "1500x1500>", medium: "750x750>", thumb: "x300>" },
                    :storage => :s3,
                    :s3_credentials => Proc.new{|a| a.instance.s3_credentials },
                    :s3_protocol => 'https',
                    :s3_host_name => "s3-us-west-2.amazonaws.com" 

  validates_attachment  :image,
                        :file_name => { :matches => /\.(gif|jpg|jpeg|tiff|png)$/i },
                        :size => { :less_than => 50.megabytes },
                        :presence => true

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

    def sorted_by(attribute)
      Upload.all.reorder("#{attribute} DESC")
    end

    def sorted_by_weighted_score
      Upload.all.sort_by(&:weighted_score).reverse!
    end

  end

end
