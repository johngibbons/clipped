class UploadModerationPolicy < Struct.new(:user, :upload_moderation)

  attr_reader :user, :upload

  def initialize(user, upload)
    @user = user
    @upload = upload
  end

  def update?
    user.admin?
  end

  def index?
    user.admin?
  end

end
