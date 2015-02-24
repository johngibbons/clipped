module Controllers  
  module SessionHelpers
    def login_admin
      login(:admin)
    end

    def log_in_as(user)
      session[:user_id] = user.id
    end

    def current_user
      User.find(request.session[:user_id])
    end
  end
end