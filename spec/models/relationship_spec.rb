require 'rails_helper'

RSpec.describe Relationship, type: :model do
  subject(:relationship) { build(:relationship) }

  it { is_expected.to be_valid }

  it "has a liker" do
    relationship.liker_id = nil
    expect(relationship).to be_invalid
  end

  it "has a liked upload" do
    relationship.liked_id = nil
    expect(relationship).to be_invalid
  end
end
