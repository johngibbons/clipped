# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create!(name:  "Example User",
             email: "example@railstutorial.org",
             password:              "password",
             password_confirmation: "password",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end

users = User.order(:created_at).take(6)
5.times do
  image =     Faker::Avatar.image
  views =     Faker::Number.number(4)
  downloads = Faker::Number.number(3)
  likes =     Faker::Number.number(3)

  users.each { |user| user.uploads.create!( image: image, 
                                            views: views, 
                                            downloads: downloads ) }
end

# Liking relationships
users = User.all
uploads = Upload.all
user = users.first
liked = uploads[2..50]
likers = users[3..40]
likers.product(liked).collect do |liker, likee|
  liker.like(likee)
end
