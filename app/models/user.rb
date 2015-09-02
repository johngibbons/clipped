class User < ActiveRecord::Base
  has_many :uploads, dependent: :destroy
  has_many :favoriter_relationships, class_name:  "Relationship",
                                 foreign_key: "favoriter_id",
                                 dependent:   :destroy
  has_many :favoriting, through: :favoriter_relationships, source: :favorited

  attr_accessor :remember_token, :activation_token, :reset_token, :avatar_original_width
  before_save   :downcase_email
  before_create :create_activation_digest

  searchable do
    text :name
    text :username
    text :email
    boolean :activated
    double :weighted_score
    time :created_at
  end
  handle_asynchronously :solr_index

  DEFAULT_AVATAR_URL = "https://s3-us-west-2.amazonaws.com/entourageappdev/users/avatars/default/profile.png"
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :username, presence: true, :length => { :in => 3..20 }, uniqueness: {case_sensitive: false}
  validates :email, presence: true, length: {maximum: 255}, format: { with: VALID_EMAIL_REGEX }, uniqueness: {case_sensitive: false}
  validates :name, length: {maximum: 50}
  #allow blank allows for profile update without changing password, password presence is ensured by 'has_secure_password' when signing up
  validates :password, length: {minimum: 8}, allow_blank: true

  has_secure_password

  has_attached_file :avatar, 
                    styles: { profile: { geometry: '300x300#', processors: [:cropper] }, large: '500x500>' },
                    :default_url => DEFAULT_AVATAR_URL,
                    :default_style => :profile,
                    :storage => :s3,
                    :s3_credentials => Proc.new{|a| a.instance.s3_credentials },
                   :s3_protocol => 'https',
                    :s3_host_name => "s3-us-west-2.amazonaws.com",
                    :bucket => ENV['AWS_BUCKET']

  after_post_process :save_image_dimensions

  validates_attachment  :avatar,
                        :size => { :less_than => 50.megabytes },
                        :content_type => { :content_type => /\Aimage/ }

  def s3_credentials
    { :bucket => ENV['AWS_BUCKET'], 
      :access_key_id => ENV['AWS_ACCESS_KEY_ID'], 
      :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'] }
  end

  def to_param
    username
  end

  def avatar_from_url(url)
    if url
      avatar_url = URI.parse(url)
      if !avatar_url.scheme
        avatar_url.scheme = 'https'
      end
      avatar_url = avatar_url.to_s
      self.avatar = URI.parse(avatar_url)
    else
      avatar_from_url(DEFAULT_AVATAR_URL)
    end
  end

  class << self
    # Returns the hash digest of the given string.
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    # Returns a random token.
    def new_token
      SecureRandom.urlsafe_base64
    end

    def sort_options
      { Newest: "created_at", Popularity: "weighted_score" }
    end

  end

  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end

  def avatar_geometry(style = :original)
    @geometry ||= {}
    avatar_path = (avatar.options[:storage] == :s3) ? avatar.url(style) : avatar.path(style)
    uri = URI(avatar_path)
    request = Net::HTTP.new uri.host
    response = request.request_head uri.path
    a = response.code.to_i
    if (response.code.to_i == 200)
      @geometry[style] ||= Paperclip::Geometry.from_file(avatar_path)
    else
      self.avatar_from_url()
      self.avatar_geometry(style)
    end
  end

  def ratio
    self.avatar_geometry(:original).width / self.avatar_geometry(:large).width
  end

  # Activates an account.
  def activate(token)
    if !self || self.activated? || !self.authenticated?(:activation, token)
      return false
    end

    update_columns(activated: true, activated_at: Time.zone.now)
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end
  
  # Creates password reset digest
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  # Sends password reset email
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Likes an upload.
  def favorite(upload)
    favoriter_relationships.create(favorited_id: upload.id)
  end

  def unfavorite(upload)
    favoriter_relationships.find_by(favorited_id: upload.id).destroy
  end

  def favoriting?(upload)
    favoriting.include?(upload)
  end

  def downloads_per_view
    self.uploads.sum(:downloads / :view)
  end

  def update_stats
    self.favorites_count = self.uploads.where(approved: true).sum(:favorites_count)
    self.downloads_count = self.uploads.where(approved: true).sum(:downloads)
    self.save!
    Sunspot.delay.index self
  end
  handle_asynchronously :update_stats

  def weighted_score
    m = ModelStatistics.new(self)
    m.composite_score_users
  end

  def upload_owner?(upload)
    if upload
      self.uploads.exists?(upload.id)
    end
  end

  # Approve an upload
  def approve(upload)
    upload.approved = true
    upload.save!
  end

  # Disapprove an upload
  def disapprove(upload)
    upload.approved = false
    upload.save!
  end

  def approved_uploads_count
    self.uploads.where(approved: true).count
  end

    #creates and assigns the activation token and digest.
  def create_activation_digest
    self.activation_token   =  User.new_token
    self.activation_digest  =  User.digest(activation_token)
  end

  def reprocess_avatar
    avatar.reprocess!
  end

  private
    #converts email to all lower-case.
    def downcase_email
      self.email = email.downcase
    end

    def save_image_dimensions
      tempfile = avatar.queued_for_write[:original]
      unless tempfile.nil?
        geometry = Paperclip::Geometry.from_file(tempfile)
        self.avatar_original_width = geometry.width.to_i
      end
    end

end
