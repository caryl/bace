require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = Factory(:user)
  end 
  should_have_db_column :login
  should_have_db_column :password
  should_have_db_column :name
  should_have_db_column :email
  should_have_db_column :remark
  should_have_db_column :state_id

  should_have_many :roles_users
  should_have_many :roles

  should_validate_uniqueness_of :login, :name, :email
  should_validate_presence_of :login, :email
  should_ensure_length_in_range :login, (2..16)
  should_ensure_length_in_range :name, (2..16)
  should_allow_values_for :email, 'aa@111.com', '89@cl.cn'
  should_not_allow_values_for :email, 'kk1l2.com', 'justastring', 'have blank@com.com'

  should_have_instance_methods :password_match?, :new_password, :new_password=, :has_permission?,
    :can_do_resource?

  context '登录验证部分' do
    setup do
      @man = Factory(:user, :login => 'man', :new_password => 'super', :name => 'man', :email => 'man@earch.sun')
    end

    should '验证密码授权' do
      assert_equal User.authenticate('man', 'super'), @man
      assert_equal User.authenticate('man', 'huge'), nil
    end

    should '检验密码匹配' do
      assert @man.password_match?('super')
      assert_equal @man.password_match?('huge'), false
    end
  end

  context "权限部分" do
    setup do
      @role =  Factory(:role)
      @role2 = Factory(:role, :name => 'role2')
      @user.roles << @role << @role2
      @permission = Factory(:permission)
      @klass = Factory(:klass)
      @meta = Factory(:meta, :klass => @klass)
      @limit_scope = Factory(:limit_scope,
        :permission=> @permission,
        :role => @role, :key_meta => @meta)
      @limit_scope2 = Factory(:limit_scope,
        :permission=> @permission,
        :role => @role2, :key_meta => @meta)
      @resource = Factory(:resource,
        :controller => 'foos',
        :action => 'bar',
        :permission => @permission)
      @role.permissions << @permission
      @role2.permissions << @permission
      @permissions_role = @role.permissions_roles.find_by_permission_id(@permission)
      @permissions_role2 = @role2.permissions_roles.find_by_permission_id(@permission)
    end

    should "用户是否有某权限" do
      assert_nil @user.has_permission?(@permission)
      @permissions_role.update_attribute(:granted, true)
      assert @user.has_permission?(@permission)
      @permissions_role2.update_attribute(:granted, false)
      assert @user.has_permission?(@permission)
      @permissions_role.update_attribute(:granted, false)
      assert_equal @user.has_permission?(@permission), false
    end

    should "可以判断是否有某资源的权限，可以生成can_do_sth?形式的方法调用" do
      assert_nil @user.can_do_resource?('foos','bar')
      assert_nil @user.can_bar_foo?
      @permissions_role.update_attribute(:granted, true)
      assert @user.can_do_resource?('foos','bar')
      assert @user.can_bar_foo?
      assert @user.can_bar_foos?
    end

    should "可以得到某个permission的scopes" do
      assert_equal @user.scopes_for_permission(@klass, @permission).flatten.compact.length, 2
      @permission.update_attribute(:free, true)
      assert @user.scopes_for_permission(@klass, @permission).blank?
    end

    should "可以得到对某个资源的scopes" do
      assert @user.scopes_for_resource(@klass, 'faos','bar').blank?
      assert_equal @user.scopes_for_resource(@klass, 'foos','bar').flatten.compact.length, 2
    end
  end
end
