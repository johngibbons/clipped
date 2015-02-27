include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :user do
    name Faker::Name.first_name
    sequence :email do |n|
      "person#{n}@example.com"
    end
    password "password"
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
    direct_upload_url "https://s3-us-west-2.amazonaws.com/entourageappdev/uploads/9a51da779b300880800edc0666e51401/john.jpg"
  end

  factory :relationship do
    liker_id 1
    liked_id 2
  end

  factory :guest_user do

  end
end 