class StaticPagesController < ApplicationController
  def home
    @recent_uploads = Upload.take(30)
  end

  def help
  end

  def about
  end

  def contact
  end
end
