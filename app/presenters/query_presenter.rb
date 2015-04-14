class QueryPresenter < BasePresenter

  def toggle(param, param_value)
    @param = param
    @param_value = param_value.to_s
    @param_current = get
    #generate copy of current params but don't affect current
    @param_new = Marshal.load(Marshal.dump(@param_current))
    if in_params?
      remove
    else
      add
    end
  end

  def query_text(total_results)
    "<span class='results-count'>#{h.pluralize(total_results, 'result')} for </span> <span class='filters-text'>#{param_to_text('category_id')} #{param_to_text('perspective_id')}</span> <span class='search-text'>\"#{@model[:search]}\"</span>"
  end

  private

    def get
      # always return an array
      p = @model["#{@param}"]
      if p.is_a? String
        p = [p]
      else
        p
      end
    end

    def add
      @param_new.push(@param_value)
      @model.merge({ "#{@param}" => @param_new })
    end

    def remove
      @param_new.delete(@param_value)
      @model.merge({ "#{@param}" => @param_new })
    end

    def in_params?
      @param_current.include? @param_value
    end

    def param_to_text(param)
      @param = param
      @param_current = get
      names = @param_current.map do |val|
        Upload.send("#{param}_name", val.to_i)
      end
      if names.any?
         names.join(" or ") + " : "
      else
        ""
      end
    end

end