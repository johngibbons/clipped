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
end
