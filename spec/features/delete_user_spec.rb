require "rails_helper"

RSpec.feature "User gets deleted", :type => :feature do

  context "User logged in" do

    before do
      @user = create(:user)
      log_in(@user)
    end

    scenario "User deletes own account", js: true, solr: true do
      visit root_path
      expect(page).to have_content(@user.name)
      visit edit_user_path(@user)
      accept_confirm do
        click_link "delete-user"
      end
      expect(page).to have_css(".static_pages.home")
      expect(page).to_not have_content(@user.name)
    end

    scenario "Admin deletes other user account", js: true, solr: true do
      visit root_path
      expect(page).to have_content(@user.name)
      @admin = create(:admin)
      visit edit_user_path(@user)
      accept_confirm do
        click_link "delete-user"
      end
      expect(page).to have_css(".static_pages.home")
      expect(page).to_not have_content(@user.name)
    end

  end
end
