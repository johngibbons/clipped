# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# Examples:

# cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
# Mayor.create(name: 'Emanuel', city: cities.first)
# User.create!(name:  "Example User",
#              email: "example@railstutorial.org",
#              password:              "password",
#              password_confirmation: "password",
#              admin: true,
#              activated: true,
#              activated_at: Time.zone.now)

99.times do |n|
  name  = Faker::Name.name
  email = Faker::Internet.email
  password = Faker::Internet.password
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               activated: true,
               activated_at: Faker::Date.backward(365),
               avatar: Faker::Avatar.image)
end

users = User.order(:created_at).take(6)

rand(3..10).times do
  image =     Faker::Avatar.image
  views =     Faker::Number.number(4)
  downloads = Faker::Number.number(3)
  favorites =     Faker::Number.number(3)
  direct_upload_url = Faker::Internet.url

  users.each { |user| user.uploads.create!( image: image, 
                                            views: views, 
                                            downloads: downloads,
                                            direct_upload_url: direct_upload_url,
                                            approved: true,
                                            processed: true ) }
end

# # Favoriting relationships
# users = User.all
# uploads = Upload.all
# user = users.first
# favorited = uploads[2..50]
# favoriters = users[3..40]
# favoriters.product(favorited).collect do |favoriter, favoritee|
#   favoriter.favorite(favoritee)
# end
