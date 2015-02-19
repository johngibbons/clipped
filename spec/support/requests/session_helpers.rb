module Requests
  module SessionHelpers  
    def log_in_as(user, options = {})
      password    = options[:password]    || 'password'
      post login_path, session: { email:       user.email,
                                  password:    password }
    end
  end
end