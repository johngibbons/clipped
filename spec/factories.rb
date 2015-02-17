FactoryGirl.define do
  factory :user do
    name "Test User"
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
    direct_upload_url "https://s3-us-west-2.amazonaws.com/entourageappdev/uploads/%7Btimestamp%7D-%7Bunique_id%7D-04a790b7c2a227a34b7f00643ed9a7d5/mountains3.jpg"
    image_file_name "image.jpg"
    image_content_type "image/jpg"
    image_file_size "30000"
    image_updated_at Time.now
  end
end 