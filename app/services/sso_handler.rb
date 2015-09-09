class SsoHandler
  include ServiceHelper
  include Virtus.model
  include UrlHelper
  require "openssl"
  require "base64"

  attribute :params, Hash
  attribute :auth_hash, Hash
  attribute :user, User

  def save_input_params
    @sig = @params["session"]["sig"]
    @sso = @params["session"]["sso"]
  end

  def forum_origin?
    @sig && @sso
  end

end
