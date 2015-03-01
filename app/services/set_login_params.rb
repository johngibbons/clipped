class SetLoginParams

  def self.call(user, params)
    params[:session] ||= { email: user.email, password: user.password }
  end

end