# in spec/support/omniauth_macros.rb
module Omniauth
  def mock_auth_hash(*args)
    # The mock_auth configuration allows you to set per-provider (or default)
    # authentication hashes to return during integration testing.
    OmniAuth.config.mock_auth[:facebook] = {
      'provider' => 'facebook',
      'uid' => '123545',
      'info' => {
        'email' => 'mockemailabcdefghijk@sample.com',
        'name' => 'mockuser',
        'image' => 'https://s3-us-west-2.amazonaws.com/entourageappdev/thumb/amanda.jpg'
      },
      'credentials' => {
        'token' => 'mock_token',
        'secret' => 'mock_secret'
      }
    }
  end
end
