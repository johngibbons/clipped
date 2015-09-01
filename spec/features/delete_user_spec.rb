require "rails_helper"

RSpec.feature "User gets deleted", :type => :feature do

  context "User logged in" do

    before do
      @user = create(:user)
      log_in(@user)
    end

    scenario "User deletes own account" do
      visit edit_user_path(@user)
      accept_confirm do
        click_link "delete-user"
      end
      expect(page).to have_css(".static_pages.home")
    end

  end
end
