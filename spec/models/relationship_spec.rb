require 'rails_helper'

RSpec.describe Relationship, type: :model do
  subject(:relationship) { build(:relationship) }

  it { is_expected.to be_valid }

  it "has a favoriter" do
    relationship.favoriter_id = nil
    expect(relationship).to be_invalid
  end

  it "has a favorited upload" do
    relationship.favorited_id = nil
    expect(relationship).to be_invalid
  end
end
