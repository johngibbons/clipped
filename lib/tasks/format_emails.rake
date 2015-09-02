namespace :update_database do
  desc "formats usernames properly from existing emails"

  task :usernames_from_emails => :environment do
    @users = User.all
    @users.each do |user|
      username = user.email[/[^@]+/]
      username = username[0,20]
      username = username.gsub(/[^\w]/, '_')
      user.username = username
      user.save!
    end
  end
end
