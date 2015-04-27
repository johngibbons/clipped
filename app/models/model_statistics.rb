class ModelStatistics
  include ActiveModel::Model

  def initialize(model)
    @model = model
    @klass = model.class
    @users = User.includes(:uploads)
  end

  def attr_values(attribute)
    vals = @klass.pluck(attribute)
    vals.map do |val|
      val.to_f
    end
  end

  def user_downloaded_vals
    User.pluck(:downloads_count)
  end

  def user_views_vals
    User.pluck(:views_count)
  end

  def user_favorites_vals
    User.pluck(:favorites_count)
  end

  def user_uploaded_vals
    @users.map do |user|
      user.uploads.where(approved: true).size
    end
  end

  def user_downloads_per_view_vals
    @users.map do |user|
      if user.views_count == 0
        0
      else
        user.downloads_count.to_f / user.views_count
      end
    end
  end

  def user_download_per_view
    if @model.views_count == 0
      0
    else
      @model.downloads_count.to_f / @model.views_count
    end
  end

  def attr_maximum(attribute)
    sorted = attr_values(attribute).sort.last
  end

  def scaled_values(attribute)
    vals = attr_values(attribute)
    vals.map do |value|
      if attr_maximum(attribute) == 0
        0
      else
        value.to_f / attr_maximum(attribute) * 100
      end
    end
  end

  def downloads_per_view
    if @model.views == 0
      0
    else
      @model.downloads.to_f / @model.views
    end
  end

  def downloads_per_view_array
    downloads = attr_values("downloads")
    views = attr_values("views")
    dpv = downloads.map.with_index do |dl, i|
      if views[i] == 0
        0
      else
        dl / views[i]
      end
    end
  end

  def composite_score_uploads
    0.5*self.z_score(downloads_per_view, downloads_per_view_array) + 0.3*self.z_score(@model.downloads, attr_values("downloads")) + 0.2*self.z_score(@model.favorites_count, attr_values("favorites_count"))
  end

  def composite_score_users
    0.2*self.z_score(user_download_per_view, user_downloads_per_view_vals) + 0.3*self.z_score(@model.uploads.where(approved: true).size, user_uploaded_vals) + 0.4*self.z_score(@model.downloads_count, user_downloaded_vals) + 0.1*self.z_score(@model.favorites_count, user_favorites_vals)
  end

  def scaled_value(attribute)
    if attr_maximum(attribute) == 0
      0
    else
      @model.send(attribute) / attr_maximum(attribute).to_f
    end
  end

  def total(attribute)
    @klass.sum(attribute)
  end

  def stats(values)
    if values
      DescriptiveStatistics::Stats.new(values)
    else
      0
    end
  end

  def z_score(value, values_array)
    stats = stats(values_array)
    if stats.standard_deviation && stats.standard_deviation != 0
      (value - stats.mean) / stats.standard_deviation
    else
      0
    end
  end

end