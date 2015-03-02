class User < ActiveRecord::Base
  has_many :uploads, dependent: :destroy
  has_many :liker_relationships, class_name:  "Relationship",
                                 foreign_key: "liker_id",
                                 dependent:   :destroy
  has_many :liking, through: :liker_relationships, source: :liked

  attr_accessor :remember_token, :activation_token, :reset_token
  before_save   :downcase_email
  before_create :create_activation_digest
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255}, format: { with: VALID_EMAIL_REGEX }, uniqueness: {case_sensitive: false}
  validates :name, length: {maximum: 50}
  #allow blank allows for profile update without changing password, password presence is ensured by 'has_secure_password' when signing up
  validates :password, length: {minimum: 8}, allow_blank: true

  has_secure_password

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
  def like(upload)
    liker_relationships.create(liked_id: upload.id)
  end

  def unlike(upload)
    liker_relationships.find_by(liked_id: upload.id).destroy
  end

  def liking?(upload)
    liking.include?(upload)
  end

  def total_user_likes
    count = 0
    self.uploads.each do |upload|
      count += upload.likes_count
    end
    count
  end

  def total_user_views
    count = 0
    self.uploads.each do |upload|
      count += upload.views
    end
    count
  end

  def upload_owner?(upload)
    self.uploads.exists?(upload.id)
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
  
  private
    #converts email to all lower-case.
    def downcase_email
      self.email = email.downcase
    end

    #creates and assigns the activation token and digest.
    def create_activation_digest
      self.activation_token   =  User.new_token
      self.activation_digest  =  User.digest(activation_token)
    end
end
