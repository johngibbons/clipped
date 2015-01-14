require 'test_helper'

class EntourageItemsControllerTest < ActionController::TestCase
  setup do
    @entourage_item = entourage_items(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:entourage_items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create entourage_item" do
    assert_difference('EntourageItem.count') do
      post :create, entourage_item: { image: @entourage_item.image, tags: @entourage_item.tags }
    end

    assert_redirected_to entourage_item_path(assigns(:entourage_item))
  end

  test "should show entourage_item" do
    get :show, id: @entourage_item
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @entourage_item
    assert_response :success
  end

  test "should update entourage_item" do
    patch :update, id: @entourage_item, entourage_item: { image: @entourage_item.image, tags: @entourage_item.tags }
    assert_redirected_to entourage_item_path(assigns(:entourage_item))
  end

  test "should destroy entourage_item" do
    assert_difference('EntourageItem.count', -1) do
      delete :destroy, id: @entourage_item
    end

    assert_redirected_to entourage_items_path
  end
end
