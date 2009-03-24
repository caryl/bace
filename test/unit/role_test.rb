require File.dirname(__FILE__) + '/../test_helper'

class RoleTest < ActiveSupport::TestCase
  def setup 
    @role = Factory(:role)
  end
  should_have_db_column :name
  should_have_db_column :parent_id
  should_have_db_column :lft
  should_have_db_column :rgt
  should_have_db_column :remark

  should_have_many :users
  should_have_many :roles_users
  should_have_many :permissions
  should_have_many :permissions_roles
  should_have_many :limit_scopes
  
  context "权限部分" do
    setup do
      @child_role = Factory(:role, :name => 'child')
      @child_role.move_to_child_of(@role)
      @permission = Factory(:permission)
      @child_permission = Factory(:permission, :name => 'child_permission')
      @child_permission.move_to_child_of(@permission)
      @meta = Factory(:meta, :klass => Factory(:klass))
      @permissions_meta = Factory(:permissions_meta, :permission => @permission, :meta => @meta)
      @permissions_meta2 = Factory(:permissions_meta, :permission => @child_permission, :meta => @meta)
      @limit_scope = Factory(:limit_scope,
        :permission=> @permission,
        :role => @role, :key_meta => @meta)
      @limit_scope2 = Factory(:limit_scope,
        :permission => @child_permission,
        :role => @child_role, :key_meta => @meta)
      @resource = Factory(:resource,
        :controller => 'foos',
        :action => 'bar',
        :permission => @permission)
      #各种关系挨个测
      @role.permissions << @permission
      @child_role.permissions << @permission
      @role.permissions << @child_permission
      @child_role.permissions << @child_permission
      @permissions_role = @role.permissions_roles.find_by_permission_id(@permission)
      @child_permissions_role = @role.permissions_roles.find_by_permission_id(@child_permission)
      @permissions_child_role = @child_role.permissions_roles.find_by_permission_id(@permission)
    end

    should "判断当前角色是否有某权限" do
      #public先返回
      @child_permission.update_attribute(:public, true)
      assert @role.self_has_permission?(@child_permission)
      @child_permission.update_attribute(:public, nil)
      
      assert_nil @role.self_has_permission?(@child_permission)
      @permissions_role.update_attribute(:granted, true)
      assert @role.self_has_permission?(@permission)
      assert @role.self_has_permission?(@child_permission)

      @child_permissions_role.update_attribute(:granted, false)
      assert @role.self_has_permission?(@permission)
      assert_equal @role.self_has_permission?(@child_permission), false
    end

    should "是否有某权限,角色继承上级" do
      #public先返回
      @permission.update_attribute(:public, true)
      assert @role.has_permission?(@child_permission)
      @permission.update_attribute(:public, nil)

      assert_nil @role.has_permission?(@permission)
      @permissions_role.update_attribute(:granted, true)
      assert @role.has_permission?(@permission)
      assert @child_role.has_permission?(@permission)

      @permissions_child_role.update_attribute(:granted, false)
      assert @role.has_permission?(@permission)
      assert_equal @child_role.has_permission?(@permission), false
    end

    should "可以判断是否有某资源的权限，可以生成can_do_sth?形式的方法调用" do
      assert_nil @role.can_do_resource?('foos','bar')
      assert_nil @role.can_bar_foo?
      @permissions_role.update_attribute(:granted, true)
      assert @role.can_do_resource?('foos','bar')
      assert @role.can_bar_foo?
      assert @role.can_bar_foos?
    end

    should "得到当前角色对permission的scopes" do
      assert_equal @role.self_scopes_for_permission(User, @permission).flatten.compact.length, 1
      assert_equal @child_role.self_scopes_for_permission(User, @child_permission).flatten.compact.length, 1
      assert @child_role.self_scopes_for_permission(User, @permission).flatten.compact.blank?
      @permission.update_attribute(:free, true)
      assert @role.self_scopes_for_permission(User, @permission).blank?
    end

    should "得到role完整的scopes" do
      assert_equal @role.scopes_for_permission(User, @permission).flatten.compact.length, 1
      assert_equal @child_role.scopes_for_permission(User, @child_permission).flatten.compact.length, 2
      assert_equal @child_role.scopes_for_permission(User, @permission).flatten.compact.length, 1
      @permission.update_attribute(:free, true)
      assert @role.scopes_for_permission(User, @permission).flatten.compact.blank?
    end
  end
end
