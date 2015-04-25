require 'test_helper'

class FavoritingTestTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @upload = uploads(:orange)
    log_in_as(@user)
  end

  test "should favorite an upload the standard way" do
    assert_difference '@upload.favoriters.count', 1 do
      post relationships_path, favorited_id: @upload.id
    end
  end

  test "should favorite an upload using ajax" do
    assert_difference '@upload.favoriters.count', 1 do
      xhr :post, relationships_path, favorited_id: @upload.id
    end
  end

  test "should unfollow an upload the standard way" do
    @user.favorite(@upload)
    relationship = @user.favoriter_relationships.find_by(favorited_id: @upload.id)
    assert_difference '@upload.favoriters.count', -1 do
      delete relationship_path(relationship)
    end
  end

  test "should unfollow an upload using ajax" do
    @user.favorite(@upload)
    relationship = @user.favoriter_relationships.find_by(favorited_id: @upload.id)
    assert_difference '@upload.favoriters.count', -1 do
      xhr :delete, relationship_path(relationship)
    end
  end
end
