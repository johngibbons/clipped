class UploadPolicy < ApplicationPolicy

  attr_reader :user, :upload

  def initialize(user, upload)
    @user = user
    @upload = upload
  end

  def update?
    admin_or_owner?
  end

  def destroy?
    admin_or_owner?
  end

  def create?
    logged_in?
  end

  def show?
    user.admin? || owner? || upload.approved?
  end

  class Scope < Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.admin? || user.upload_owner?(scope.first)
        scope.all
      else
        scope.where(:approved => true)
      end
    end
  end

  private

    def admin_or_owner?
      user.admin? || user.upload_owner?(upload)
    end

    def owner?
      user.upload_owner?(upload)
    end

    def logged_in?
      user.email != ""
    end

end