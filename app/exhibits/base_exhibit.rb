class BaseExhibit < SimpleDelegator
  def initialize(model, context)
    @model = model
    @context = context
    super(@model)
  end

end