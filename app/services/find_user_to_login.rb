class FindUserToLogin
  include ServiceHelper
  include Virtus.model

  attribute :auth_hash, Hash
  attribute :params, Hash

  def call
    if @auth_hash
      from_omniauth
    else
      User.find_by(email: @params["session"]["email"].downcase) || GuestUser.new
    end
  end

  private

    def from_omniauth
      if valid_auth_hash
        User.find_by(email: @auth_hash["info"]["email"]) || create_with_omniauth
      else
        GuestUser.new
      end
    end

    def create_with_omniauth
      User.create! do |user|
        user.provider = @auth_hash["provider"]
        user.uid  = @auth_hash["uid"]
        user.name = @auth_hash["info"]["name"]
        user.email = @auth_hash["info"]["email"]
        user.password = user.password_confirmation = SecureRandom.urlsafe_base64(n=6)
        user.activated = true
        user.activated_at = Time.zone.now
      end
    end

    def valid_auth_hash
      @auth_hash["provider"] && @auth_hash["uid"] && @auth_hash["info"] && @auth_hash["info"]["email"] && @auth_hash["info"]["name"]
    end
end