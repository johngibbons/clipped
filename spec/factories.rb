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
    direct_upload_url "https://s3-us-west-2.amazonaws.com/entourageappdev/uploads/08c4e4f590e95a0c9dbce9ae28e1c156/3.jpg"
  end
  
  factory :relationship do
    liker_id 1
    liked_id 2
  end

  factory :guest_user do

  end
end 