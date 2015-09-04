include ActionDispatch::TestProcess

FactoryGirl.define do  



  factory :user do

    name Faker::Name.first_name

    sequence :username do |n|
      "userName_#{n}"
    end

    avatar_file_name "test.png"
    avatar_content_type "image/png"
    avatar_file_size  "1024"
    avatar_updated_at Time.now

    sequence :email do |n|
      "person#{n}@example.com"
    end

    sequence :password do |n|
      "password#{n}"
    end

    activated true

    factory :uploaded_avatar do
      avatar { fixture_file_upload(Rails.root.join("spec", "support", "test.png"), "image/png") }
    end

    factory :admin do
      admin true
    end

    factory :not_activated do
      activated false
    end

  end

  factory :upload do

    user
    image_file_name "test.png"
    image_content_type "image/png"
    image_file_size "1024"
    image_updated_at Time.now
    direct_upload_url "https://s3-us-west-2.amazonaws.com/entourageappdev/uploads/150820/38cf45f9c4ff4da33eec95e5de6f54c1/DSCF5092.png"
    dz_thumb { fixture_file_upload(Rails.root.join("spec/support/test.png"), 'image/png') }

    factory :uploaded_upload do
      direct_upload_url "https://s3-us-west-2.amazonaws.com/entourageappdev/uploads/150820/38cf45f9c4ff4da33eec95e5de6f54c1/DSCF5092.png"
      dz_thumb { fixture_file_upload(Rails.root.join("spec/support/test.png"), 'image/png') }
    end

    factory :approved_upload do
      approved true
    end

  end

  factory :relationship do
    favoriter_id 1
    favorited_id 2
  end

  factory :comment do
    body "MyText"
    commenter_id 1
    commentee_id 2
  end

  factory :guest_user do

  end
end 
