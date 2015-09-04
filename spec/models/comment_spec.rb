require 'rails_helper'

RSpec.describe Comment, type: :model do

  subject(:comment) { build(:comment) }

  it { is_expected.to be_valid }

  it "has a commenter" do
    comment.commenter_id = nil
    expect(comment).to be_invalid
  end

  it "has a commentee" do
    comment.commentee_id = nil
    expect(comment).to be_invalid
  end

  it "has a text body" do
    comment.body = nil
    expect(comment).to be_invalid
  end

  it "belongs to a commenter" do
    expect(comment).to belong_to(:commenter).
    class_name("User")
  end

  it "belongs to a commentee" do
    expect(comment).to belong_to(:commentee).
    class_name("Upload")
  end

end
