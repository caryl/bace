require 'test_helper'

class DynamicSearchesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:dynamic_searches)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create dynamic_search" do
    assert_difference('DynamicSearch.count') do
      post :create, :dynamic_search => { }
    end

    assert_redirected_to dynamic_search_path(assigns(:dynamic_search))
  end

  test "should show dynamic_search" do
    get :show, :id => dynamic_searches(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => dynamic_searches(:one).to_param
    assert_response :success
  end

  test "should update dynamic_search" do
    put :update, :id => dynamic_searches(:one).to_param, :dynamic_search => { }
    assert_redirected_to dynamic_search_path(assigns(:dynamic_search))
  end

  test "should destroy dynamic_search" do
    assert_difference('DynamicSearch.count', -1) do
      delete :destroy, :id => dynamic_searches(:one).to_param
    end

    assert_redirected_to dynamic_searches_path
  end
end
