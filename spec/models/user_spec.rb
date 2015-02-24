require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { build(:user) }

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

  describe(".new_token") do
    it "returns a random token" do
      expect(User.new_token).to_not eq(User.new_token)
    end
  end

  describe "#activate" do
    it "activates user" do
      user.activated = false
      user.save
      user.activate
      expect(user).to be_activated
    end
  end

  describe "#create_reset_digest" do
    it "create reset token" do
      user = create(:user)
      expect(user.reset_token).to be_nil
      expect(user.reset_digest).to be_nil
      expect(user.reset_sent_at).to be_nil
      user.create_reset_digest
      expect(user.reset_token).to_not be_nil
      expect(user.reset_digest).to_not be_nil
      expect(user.reset_sent_at).to_not be_nil
    end
  end

  describe "#password_reset_expired?" do
    it "returns false when password reset token sent less than 2 hours ago" do
      user = create(:user)
      user.create_reset_digest
      expect(user.password_reset_expired?).to eq(false)
    end

    it "returns true when password reset token sent 2 hours ago or more" do
      user = create(:user)
      user.create_reset_digest
      user.reset_sent_at = 2.hours.ago
      expect(user.password_reset_expired?).to eq(true)
    end
  end

  describe "#remember" do
    it "creates remember token for persistent sessions" do
      user = create(:user)
      expect(user.remember_token).to be_nil
      expect(user.remember_digest).to be_nil
      user.remember
      expect(user.remember_token).to_not be_nil
      expect(user.remember_digest).to_not be_nil
    end
  end

  describe "#authenticated?" do
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

  describe "#forget" do
    it "deletes remember token to forget user session" do
      user = create(:user)
      user.remember
      expect(user.remember_digest).to_not be_nil
      user.forget
      expect(user.remember_digest).to be_nil
    end
  end

end
