require File.dirname(__FILE__) + '/../test_helper'

class PermissionTest < ActiveSupport::TestCase
  def setup
    @permission = Factory(:permission)
  end
  
  should_have_db_column :name
  should_have_db_column :public
  should_have_db_column :parent_id
  should_have_db_column :lft
  should_have_db_column :rgt
  should_have_db_column :remark

  should_have_many :permissions_roles
  should_have_many :roles
  should_have_many :resources
  should_have_many :permission_metas
  should_have_many :metas
  should_have_many :limit_scope

  should "可以继承上级的public定义" do
    child = Factory(:permission, :name => 'child')
    child.move_to_child_of(@permission)
    assert_nil child.can_public?

    @permission.update_attribute(:public, true)
    assert child.can_public?

    @permission.update_attribute(:public, false)
    assert_equal child.can_public?, false

    @permission.update_attribute(:public, nil)
    child.update_attribute(:public, true)

    assert child.can_public?
  end

  should "判断是否某角色拥有本权限" do
    role = Factory(:role)
    assert_nil @permission.granted_to_role?(role)
    role.permissions << @permission
    assert_nil @permission.granted_to_role?(role)

    permissions_role = role.permissions_roles.first
    permissions_role.update_attribute(:granted, true)
    assert @permission.granted_to_role?(role)

    permissions_role.update_attribute(:granted, false)
    assert_equal @permission.granted_to_role?(role), false
  end
end
