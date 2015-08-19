class Upload < ActiveRecord::Base
  belongs_to :user
  has_many :favorited_relationships, class_name:  "Relationship",
                                 foreign_key: "favorited_id",
                                 dependent:   :destroy
  has_many :favoriters, through: :favorited_relationships
  default_scope -> { order(created_at: :desc) }
  acts_as_ordered_taggable

  searchable do
    text :tag_list
    text :perspective
    text :category
    boolean :approved
    integer :perspective_id
    integer :category_id
    integer :season_id
    integer :ethnicity_id
    integer :gender_id
    double :weighted_score
    time :created_at
  end
  handle_asynchronously :solr_index
  # handle_asynchronously :remove_from_index

  validates :user_id, presence: true

  enum perspective: [ :not_applicable, :front, :side_front, :side, :side_back, :back, :above, :below ]
  enum category: [:uncategorized, :people, :animals, :plants, :vehicles, :objects]
  enum season: [:no_season, :summer, :fall, :winter, :spring]
  enum ethnicity: [:no_ethnicity, :african_american, :white, :hispanic, :middle_eastern, :asian]
  enum gender: [:no_gender, :male, :female, :mixed]

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


  def enum_id(attribute)
    Upload.send("#{attribute.pluralize}")[self.send("#{attribute}")]
  end

  def perspective_id
    enum_id("perspective")
  end

  def category_id
    enum_id("category")
  end

  def weather_id
    enum_id("weather")
  end

  def gender_id
    enum_id("gender")
  end

  def ethnicity_id
    enum_id("ethnicity")
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

  def weighted_score
    stats = ModelStatistics.new(self)
    stats.composite_score_uploads
  end

  class << self

    def sorted_by(attribute)
      Upload.all.reorder("#{attribute} DESC")
    end

    def enum_list
      ["perspective", "category", "season", "gender", "ethnicity"]
    end

    def enum_array(attribute)
      a = Upload.send("#{attribute.pluralize}").map do |k, v|
        [k.humanize, k]
      end
      return a
    end

    def sort_options
      {Relevance: "", Newest: "created_at", Popularity: "weighted_score"}
    end

    def enum_id_name(attribute, int)
      name = Upload.send("#{attribute.pluralize}").map do |key, value|
        key.humanize
      end
      return name[int]
    end

  end

end
