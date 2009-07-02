require File.dirname(__FILE__) + '/../test_helper'

class LimitGroupsControllerTest < ActionController::TestCase
=begin
  context 'GET to index' do
    setup do
      get :index
    end
    should_respond_with :success
    should_assign_to :limit_groups
  end

  context 'GET to new' do
    setup do
      get :new
    end

    should_respond_with :success
    should_render_template :new
    should_assign_to :limit_group
  end

  context 'POST to create' do
    setup do
      post :create, :limit_group => Factory.attributes_for(:limit_group)
      @limit_group = LimitGroup.find(:all).last
    end
    
    should_redirect_to('POST to create'){limit_group_path(@limit_group)}
  end

  context 'GET to show' do
    setup do
      @limit_group = Factory(:limit_group)
      get :show, :id => @limit_group.id
    end
    should_respond_with :success
    should_render_template :show
    should_assign_to :limit_group
  end

  context 'GET to edit' do
    setup do
      @limit_group = Factory(:limit_group)
      get :edit, :id => @limit_group.id
    end
    should_respond_with :success
    should_render_template :edit
    should_assign_to :limit_group
  end

  context 'PUT to update' do
    setup do
      @limit_group = Factory(:limit_group)
      put :update, :id => @limit_group.id, :limit_group => Factory.attributes_for(:limit_group)
    end
    should_redirect_to('PUT to update'){limit_group_path(@limit_group)}
  end

  context 'DELETE to destroy' do
    setup do
      @limit_group = Factory(:limit_group)
      delete :destroy, :id => @limit_group.id
    end
    should_redirect_to('DELETE to destroy'){limit_groups_path}
  end
=end
end
