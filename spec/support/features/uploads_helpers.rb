module Features
  module UploadsHelpers  
    def upload_images_as(user)
      2.times do
        create(:upload, user: user)
      end
    end
  end
end