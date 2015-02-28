require 'delegate'
class BasePresenter < SimpleDelegator
  def initialize(model, view)
    @model = model
    @view = view
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
end