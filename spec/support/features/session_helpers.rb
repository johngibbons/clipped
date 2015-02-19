module Features
  module SessionHelpers  
    def sign_up_with(email, password)
      visit signup_path
      fill_in 'Email', with: email
      fill_in 'Password', with: password
      fill_in 'Confirmation', with: password
      click_button 'Create Profile'
    end

    def sign_in
      user = create(:user)
      visit login_path
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button 'Log In'
    end
  end
end