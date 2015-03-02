class UserPolicy < ApplicationPolicy

  attr_reader :current_user, :model

  def initialize(current_user, model)
    @current_user = current_user
    @user = model
  end

  def show?
    @user.activated?
  end

  def update?
    current_or_admin
  end

  def destroy?
    current_or_admin
  end

  class Scope < Scope
    attr_reader :current_user, :scope

    def initialize(current_user, scope)
      @current_user = current_user
      @scope = scope
    end

    def resolve
      scope.where(:activated => true)
    end
  end

  private

  def current_or_admin
    current_user.admin? || current_user == @user
  end

end