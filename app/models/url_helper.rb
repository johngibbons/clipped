# helper for creating redirects with urls
module UrlHelper
  def generate_url(url, params = {})
    byebug
    uri = URI(url)
    uri.query = params.to_query
    uri.to_s
  end
end
