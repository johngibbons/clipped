class LogInUser

  def initialize(user, params)
    @user = user
    @params = params
  end

  def login(user)
    user.authenticate(@params[:session][:password])
  end

end