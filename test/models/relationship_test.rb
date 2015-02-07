require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase
  def setup
    @relationship = Relationship.new(liker_id: 1, liked_id: 2)
  end

  test "should be valid" do
    assert @relationship.valid?
  end

  test "should require a liker_id" do
    @relationship.liker_id = nil
    assert_not @relationship.valid?
  end

  test "should require a liked_id" do
    @relationship.liked_id = nil
    assert_not @relationship.valid?
  end
end
