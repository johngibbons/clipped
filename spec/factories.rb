include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :user do
    name Faker::Name.first_name
    sequence :email do |n|
      "person#{n}@example.com"
    end
    password "password"

    factory :admin do
      admin true
    end

  end

  factory :upload do
    user
    image { Rack::Test::UploadedFile.new(Rails.root.join("spec/support/test.png"), 'image/png') }
    direct_upload_url "https://amazon.s3.com/upload/test.png"
  end

  factory :relationship do
    liker_id 1
    liked_id 2
  end

  factory :guest_user do

  end
end 