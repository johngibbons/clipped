class LogInUsers

  def initialize(auth_hash, params)
    @auth_hash = auth_hash
    @params = params
  end

  def get_user
    if @auth_hash.nil?
      User.find_by(email: @params[:session][:email].downcase)
    else
      from_omniauth
    end
  end

  def login(user)
    if user.email == ""
      false
    else
      user.authenticate(@params[:session][:password]) || user.provider
    end
  end

    private

    def from_omniauth
      if @auth_hash["info"]
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

end