namespace :update_database do
  desc "creates usernames from existing emails"

  task :usernames_from_emails => :environment do
    @users = User.where(username: nil)
    @users.each do |user|
      username = user.email[/[^@]+/]
      username = username[0,20]
      user.username = username
      user.save!
    end
  end
end
