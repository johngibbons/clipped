class AuthenticateUser

  include ServiceHelper
  include Virtus.model

  attribute :user, User
  attribute :params, Hash
  attribute :auth_hash, Hash

  def success?
    (auth_hash || authenticated?) && @user.activated?
  end

  def error
    if auth_hash || !authenticated?
      'Invalid email/password combination'
    elsif !@user.activated?
      "Account not activated.  Check your email for activation link."
    end
  end

  private
    def authenticated?
      @user.authenticate(@params["session"]["password"])
    end

end