class Upload < ActiveRecord::Base
  belongs_to :user
  has_many :liked_relationships, class_name:  "Relationship",
                                 foreign_key: "liked_id",
                                 dependent:   :destroy
  has_many :likers, through: :liked_relationships
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  has_attached_file :image, 
                    styles: { original: "4000x4000>", large: "1500x1500>", medium: "750x750>", thumb: "250x250>" },
                    :storage => :s3,
                    :s3_credentials => Proc.new{|a| a.instance.s3_credentials },
                    :s3_protocol => 'https',
                    :s3_host_name => "s3-us-west-2.amazonaws.com" 

  validates_attachment  :image, :presence => true,
                        :content_type => { :content_type => /\Aimage\/.*\Z/ },
                        :size => { :less_than => 50.megabytes }

  def s3_credentials
    { :bucket => ENV['S3_BUCKET'], 
      :access_key_id => ENV['S3_ACCESS_KEY'], 
      :secret_access_key => ENV['S3_SECRET_KEY'] }
  end
end
