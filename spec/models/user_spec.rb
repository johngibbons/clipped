require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { FactoryGirl.build(:user) }

  it { is_expected.to be_valid }

  it "has email address" do
    user.email = ""
    expect(user).to be_invalid
  end

  it "has name no more than 50 chars" do
    user.name = "a" * 51
    expect(user).to be_invalid
  end

  it "has email no more than 255 chars" do
    user.email = "a" * 244 + "@example.com"
    expect(user).to be_invalid
  end

  it "accepts valid email addresses" do
    valid_addresses = %w[sample@example.com sAmPle@example.net
      s_ampLe@example-site.io A_Us-er@foo.bar.org first.last@foo.jp 
      example+name@baz.cn]
    valid_addresses.each do |valid_address|
      user.email = valid_address
      expect(user).to be_valid, "#{valid_address.inspect} should be valid"
    end
  end

  it "rejects invalid email addresses" do
    invalid_addresses = %w[sample@example,com user_at_foo.org user.name@example.
      foo@bar_baz.com foo@bar+baz.com Fo0@bar..com]
    invalid_addresses.each do |invalid_address|
      user.email = invalid_address
      expect(user).to be_invalid, "#{invalid_address.inspect} should not be valid"
    end
  end

  it "has a unique email address" do
    user.save
    duplicate_user = FactoryGirl.build(:user, email: user.email.upcase)
    expect(duplicate_user).to be_invalid
  end

  it "has a downcased email address" do
    mixed_case_email = "ExAmPle@SaMple.com"
    user.email = mixed_case_email
    user.save
    expect(user.email).to eq("example@sample.com")
  end

  it "has at least 8 char long password" do
    user.password = "a" * 7
    expect(user).to be_invalid
  end

  describe ".authenticated?" do
    it "is true when digest matches given token" do
      expect(user.authenticated?(:password, user.password)).to eq true
    end

    it "is false when digest doesn't match given token" do
      expect(user.authenticated?(:password, "wrongpassword")).to eq false
    end

    it "is false when digest is nil" do
      expect(user.authenticated?(:remember, '')).to eq false
    end
  end

  describe ".activate" do
    it "activates user" do
      user.activated = false
      user.save
      user.activate
      expect(user).to be_activated
    end
  end


end
