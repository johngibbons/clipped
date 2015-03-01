class LogInUser

  include ServiceHelper
  include Virtus.model

  attribute :user, User
  attribute :params, Hash

  def success?
    authenticate_user && @user.activated?
  end

  def error
    if !authenticate_user
      'Invalid email/password combination'
    elsif !@user.activated?
      "Account not activated.  Check your email for activation link."
    end
  end

  private
    def authenticate_user
      @user.authenticate(@params["session"]["password"])
    end

end