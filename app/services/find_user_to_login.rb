class FindUserToLogin
  include ServiceHelper
  include Virtus.model

  attribute :auth_hash, Hash
  attribute :params, Hash

  def call
    if @auth_hash
      from_omniauth
    else
      if User::VALID_EMAIL_REGEX.match(@params["session"]["username_or_email"])
        User.find_by(email: @params["session"]["username_or_email"].downcase) || GuestUser.new
      else
        User.find_by(username: @params["session"]["username_or_email"]) || GuestUser.new
      end
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
      new_user = User.new do |user|
        user.provider = @auth_hash["provider"]
        user.uid  = @auth_hash["uid"]
        user.name = @auth_hash["info"]["name"]
        user.email = @auth_hash["info"]["email"]
        username = user.email[/[^@]+/]
        username = username[0,20]
        user.username = username
        user.password = user.password_confirmation = SecureRandom.urlsafe_base64(n=6)
        user.activated = true
        user.activated_at = Time.zone.now
        user.avatar_from_url(@auth_hash["info"]["image"])
      end

      if new_user.valid?
        new_user.save
      elsif new_user.errors.messages[:username] == ["has already been taken"]
        n = 1
        while new_user.errors.messages[:username]
          new_user.username = new_user.username[0,(20 - n.to_s.size)] + n.to_s
          n += 1
          new_user.valid?
        end
        new_user.save
      else
        return GuestUser.new
      end

      new_user
    end

    def valid_auth_hash
      @auth_hash["provider"] && @auth_hash["uid"] && @auth_hash["info"] && @auth_hash["info"]["email"] && @auth_hash["info"]["name"]
    end
end
