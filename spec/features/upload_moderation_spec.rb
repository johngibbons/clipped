require "rails_helper"

RSpec.feature "Uploads Moderation", :type => :feature do

  subject(:user) { create(:user) }

  scenario "non admin user doesn't see moderation tools" do
  end

end
