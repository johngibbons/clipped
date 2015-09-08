module ApplicationHelper

  def full_title(page_title = "")
    base_title = "Clipped"
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end


  def present(model, presenter_class=nil, user=current_user)
    klass = presenter_class || "#{model.class}Presenter".constantize
    presenter = klass.new(model, self, user)
    yield(presenter) if block_given?
  end

end
