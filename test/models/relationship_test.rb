require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase
  def setup
    @relationship = Relationship.new(favoriter_id: 1, favorited_id: 2)
  end

  test "should be valid" do
    assert @relationship.valid?
  end

  test "should require a favoriter_id" do
    @relationship.favoriter_id = nil
    assert_not @relationship.valid?
  end

  test "should require a favorited_id" do
    @relationship.favorited_id = nil
    assert_not @relationship.valid?
  end
end
