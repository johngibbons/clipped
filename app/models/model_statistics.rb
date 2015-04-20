class ModelStatistics
  include ActiveModel::Model

  def initialize(model)
    @model = model
    @klass = model.class
  end

  def attr_values(attribute)
    vals = @klass.pluck(attribute)
    vals.map do |val|
      val.to_f
    end
  end

  def user_downloaded_vals
    users = @klass.all
    users.map do |user|
      user.total_user_downloads
    end
  end

  def user_views_vals
    users = @klass.all
    users.map do |user|
      user.total_user_views
    end
  end

  def user_likes_vals
    users = @klass.all
    users.map do |user|
      user.total_user_likes
    end
  end

  def user_uploaded_vals
    users = @klass.all
    users.map do |user|
      user.uploads.length
    end
  end

  def user_downloads_per_view_vals
    views = user_views_vals
    downloads = user_downloaded_vals
    dpv = downloads.map.with_index do |dl, i|
      if views[i] == 0
        0
      else
        dl / views[i]
      end
    end
  end

  def user_download_per_view
    if @model.total_user_views == 0
      0
    else
      @model.total_user_downloads / @model.total_user_views
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

  def composite_score_uploads
    0.5*self.z_score(downloads_per_view, downloads_per_view_array) + 0.3*self.z_score(@model.downloads, attr_values("downloads")) + 0.2*self.z_score(@model.likes_count, attr_values("likes_count"))
  end

  def composite_score_users
    0.4*self.z_score(user_download_per_view, user_downloads_per_view_vals) + 0.3*self.z_score(@model.uploads.length, user_uploaded_vals) + 0.2*self.z_score(@model.total_user_downloads, user_downloaded_vals) + 0.1*self.z_score(@model.total_user_likes, user_likes_vals)
  end

  def downloads_per_view
    @model.downloads.to_f / @model.views
  end

  def downloads_per_view_array
    downloads = attr_values("downloads")
    views = attr_values("views")
    dpv = downloads.map.with_index {|dl, i| dl / views[i]}
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
    DescriptiveStatistics::Stats.new(values)
  end

  def z_score(value, values_array)
    stats = stats(values_array)
    if stats.standard_deviation == 0
      0
    else
      (value - stats.mean) / stats.standard_deviation
    end
  end

end