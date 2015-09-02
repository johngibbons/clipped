module Features
  module SessionHelpers  
    def sign_up_with(username:, email:, password:)
      visit signup_path
      fill_in "Username", with: username
      fill_in 'Email', with: email
      fill_in 'Password', with: password
      fill_in 'Confirmation', with: password
      click_button 'Create Profile'
    end

    def log_in(user)
      visit login_path
      fill_in 'Username or email', with: user.email
      fill_in 'Password', with: user.password
      click_button 'Log In'
    end
  end
end
