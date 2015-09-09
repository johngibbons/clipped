class SsoHandler
  include ServiceHelper
  include Virtus.model
  include UrlHelper
  require "openssl"
  require "base64"

  attribute :user, User
  attribute :params, Hash

  def self.call
    @sig = params[:session][:sig]
    @sso = params[:session][:sso]
  end

  def return_params
    if legitimate_request?
      generate_encoded_params
    end
  end

  def forum_origin?
    @sig && @sso
  end

  private

    def legitimate_request?
      OpenSSL::HMAC.hexdigest('sha256', ENV["SSO_SECRET"], @sso) == @sig
    end

    def generate_encoded_params
      nonce = Base64.decode64(@sso)
      @sso = Base64.encode64(nonce + '&username=' + @user.username + '&email=' + @user.email + '&external_id=' + @user.id.to_s)
      @sig = OpenSSL::HMAC.hexdigest('sha256', ENV["SSO_SECRET"], @sso)
      { sso: @sso, sig: @sig }
    end

end
