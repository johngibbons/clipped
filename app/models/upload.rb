class Upload < ActiveRecord::Base
  belongs_to :user
  has_many :liked_relationships, class_name:  "Relationship",
                                 foreign_key: "liked_id",
                                 dependent:   :destroy
  has_many :likers, through: :liked_relationships
  default_scope -> { order(created_at: :desc) }
  acts_as_ordered_taggable

  searchable do
    text :tag_list
    text :perspective
    text :category
    boolean :approved
    integer :perspective_id
    integer :category_id
    time :created_at
  end
  handle_asynchronously :solr_index
  # handle_asynchronously :remove_from_index

  validates :user_id, presence: true

  enum perspective: [ :not_applicable, :front, :side_front, :side, :side_back, :back, :above, :below ]
  enum category: [:uncategorized, :people, :animals, :plants, :objects]

  # Store an unescaped version of the escaped URL that Amazon returns from direct upload.
  def direct_upload_url=(escaped_url)
    write_attribute(:direct_upload_url, (CGI.unescape(escaped_url) rescue nil))
  end

  has_attached_file :image, 
                    styles: { original: "4000x4000>", large: "1500x1500>", medium: "750x750>", thumb: "x300>" },
                    :storage => :s3,
                    :s3_credentials => Proc.new{|a| a.instance.s3_credentials },
                    :s3_protocol => 'https',
                    :s3_host_name => "s3-us-west-2.amazonaws.com",
                    :bucket => ENV['AWS_BUCKET']

  validates_attachment  :image,
                        :file_name => { :matches => /\.(gif|jpg|jpeg|tiff|png)$/i },
                        :size => { :less_than => 50.megabytes },
                        :presence => true

  def s3_credentials
    { :bucket => ENV['AWS_BUCKET'], 
      :access_key_id => ENV['AWS_ACCESS_KEY_ID'], 
      :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'] }
  end

  def perspective_id
    Upload.perspectives[self.perspective]
  end

  def category_id
    Upload.categories[self.category]
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

  def download_url
    s3 = AWS::S3.new
    bucket = s3.buckets[image.bucket_name]
    object = bucket.objects[image.s3_object(:original).key]
    object.url_for(:get,
      expires: 10.minutes,
      response_content_disposition: 'attachment'
    ).to_s
  end

  class << self

    def sorted_by(attribute)
      Upload.all.reorder("#{attribute} DESC")
    end

    def sorted_by_weighted_score
      Upload.all.sort_by(&:weighted_score).reverse!
    end

    def perspective_collection(perspectives = [])
      Upload.where(perspective: perspectives)
    end

    def perspective_array
      a = Upload.perspectives.map do |k,v|
        [k.humanize, k]
      end
      return a
    end

    def category_array
      a = Upload.categories.map do |k,v|
        [k.humanize, k]
      end
      return a
    end

    # def perspective_choices
    #   byebug
    #   Upload.perspectives.except!(:not_applicable)
    # end

    def category_collection(categories = [])
      Upload.where(category: categories)
    end

    def perspective_name(int)
      name = Upload.perspectives.map do |key, value|
        key.humanize
      end
      return name[int]
    end

    def category_name(int)
      name = Upload.categories.map do |key, value|
        key.humanize
      end
      return name[int]
    end

    # def category_choices
    #   Upload.categories.except!(:uncategorized)
    # end

  end

end
