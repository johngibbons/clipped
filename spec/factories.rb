include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :user do
    name Faker::Name.first_name
    avatar { Rack::Test::UploadedFile.new(Rails.root.join("spec/support/test.png"), 'image/png') }
    sequence :email do |n|
      "person#{n}@example.com"
    end
    sequence :password do |n|
      "password#{n}"
    end
    activated true

    factory :admin do
      admin true
    end

    factory :not_activated do
      activated false
    end

  end

  factory :upload do
    user
    image { Rack::Test::UploadedFile.new(Rails.root.join("spec/support/test.png"), 'image/png') }
    direct_upload_url "https://s3-us-west-2.amazonaws.com/entourageappdev/uploads/0f3ca9c7e90405ef0554ebe513160c93/BlueSearchResults.png"

    factory :approved_upload do
      approved true
    end

  end
  
  factory :relationship do
    favoriter_id 1
    favorited_id 2
  end

  factory :guest_user do

  end
end 