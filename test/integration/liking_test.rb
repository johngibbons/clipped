require 'test_helper'

class LikingTestTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @upload = uploads(:orange)
    log_in_as(@user)
  end

  test "should like an upload the standard way" do
    assert_difference '@upload.likers.count', 1 do
      post relationships_path, liked_id: @upload.id
    end
  end

  test "should like an upload using ajax" do
    assert_difference '@upload.likers.count', 1 do
      xhr :post, relationships_path, liked_id: @upload.id
    end
  end

  test "should unfollow an upload the standard way" do
    @user.like(@upload)
    relationship = @user.liker_relationships.find_by(liked_id: @upload.id)
    assert_difference '@upload.likers.count', -1 do
      delete relationship_path(relationship)
    end
  end

  test "should unfollow an upload using ajax" do
    @user.like(@upload)
    relationship = @user.liker_relationships.find_by(liked_id: @upload.id)
    assert_difference '@upload.likers.count', -1 do
      xhr :delete, relationship_path(relationship)
    end
  end
end
