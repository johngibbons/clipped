require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Sample User", email: "sample@example.com", password: "password", password_confirmation: "password")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "email should be present" do
    @user.email = ""
    assert_not @user.valid?
  end

  test "name should be no more than 50 chars" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should be no more than 255 chars" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[sample@example.com sAmPle@example.net
      s_ampLe@example-site.io A_Us-er@foo.bar.org first.last@foo.jp 
      example+name@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should not accept invalid addresses" do
    invalid_addresses = %w[sample@example,com user_at_foo.org user.name@example.
      foo@bar_baz.com foo@bar+baz.com Fo0@bar..com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should not be valid"
    end
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email addresses should be downcased" do
    mixed_case_email = "SaMple@eXaMplE.com"
    @user.email = mixed_case_email
    @user.save
    assert_equal @user.reload.email, mixed_case_email.downcase
  end

  test "password should be at least 8 characters long" do
    @user.password = @user.password_confirmation = "a" * 7
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end

  test "user from omniauth" do
    num_of_users = User.count
    auth = OmniAuth.config.mock_auth[:identity]
    User.from_omniauth(auth)
    assert_equal num_of_users+1, User.count, "number of users is #{num_of_users}"

    user = User.last
    username = ""
    auth.slice(:provider, :uid).try do
      username = auth.info.name
    end
    assert_equal username, user.name, "Username"
  end

  test "associated uploads should be destroyed" do
    @user.save
    @user.uploads.create!(image_file_name: "image.jpg", direct_upload_url: "http://s3.amazon.com/image.jpg")
    assert_difference 'Upload.count', -1 do
      @user.destroy
    end
  end

  test "should like and unlike an upload" do
    michael = users(:michael)
    upload = uploads(:orange)
    assert_not michael.liking?(upload)
    michael.like(upload)
    assert michael.liking?(upload)
    assert upload.likers.include?(michael)
    michael.unlike(upload)
    assert_not michael.liking?(upload)
  end
end
