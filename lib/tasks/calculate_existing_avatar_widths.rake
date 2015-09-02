namespace :update_database do
  desc "calculates existing avatar widths"

  task :calculate_avatars => :environment do
    @users = User.where(avatar_original_width: 0)
    @users.each do |user|
      user.avatar.
      user.save!
    end
  end
end
