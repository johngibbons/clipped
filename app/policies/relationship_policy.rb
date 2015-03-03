class RelationshipPolicy < ApplicationPolicy

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def create?
    logged_in?
  end

  def destroy?
    logged_in?
  end

end