class User < ActiveRecord::Base
  attr_accessor :remember_token, :activation_token
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

    def from_omniauth(auth)
      find_by_email(auth["info"]["email"]) || create_with_omniauth(auth)
    end

    def create_with_omniauth(auth)
      create! do |user|
        user.provider = auth["provider"]
        user.uid  = auth["uid"]
        user.name = auth["info"]["name"]
        user.email = auth["info"]["email"]
        user.password = user.password_confirmation = SecureRandom.urlsafe_base64(n=6)
        user.activated = true
        user.activated_at = Time.zone.now
      end
    end
  end

  # Activates an account.
  def activate
    update_attribute(:activated, true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
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
