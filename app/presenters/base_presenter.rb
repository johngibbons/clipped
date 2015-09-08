require 'delegate'
class BasePresenter < SimpleDelegator
  def initialize(model, view, user)
    @model = model
    @view = view
    @user = user
    super(@model)
  end

  def class
    __getobj__.class
  end

  def to_model
    __getobj__
  end

  def h
    @view
  end

  def u
    @user
  end
end
