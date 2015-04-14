class QueryPresenter < BasePresenter

  def get(param)
    # always return an array
    p = @model["#{param}"]
    if p.is_a? String
      p = [p]
    else
      p
    end
  end

  def add(param, param_new)
    p_current = self.get(param)
    p_new = Marshal.load(Marshal.dump(p_current)).push(param_new)
    @model.merge({ "#{param}" => p_new })
  end

end