require File.dirname(__FILE__) + '/../test_helper'

class LimitScopeTest < ActiveSupport::TestCase
  def setup
    @limit_scope = Factory(:limit_scope)
  end
  should_have_db_column :role_id
  should_have_db_column :permission_id
  should_have_db_column :target_meta_id
  should_have_db_column :target_klass_id
  should_have_db_column :key_meta_id
  should_have_db_column :prefix
  should_have_db_column :op
  should_have_db_column :value_meta_id
  should_have_db_column :value
  should_have_db_column :suffix
  should_have_db_column :logic
  should_have_db_column :position
 
  should_belong_to :role
  should_belong_to :permission
  should_belong_to :key_meta
  should_belong_to :value_meta
  should_belong_to :target_meta
  should_belong_to :target_klass

  should_have_instance_methods :to_condition
  should_have_class_methods :join_conditions
  should_validate_presence_of :role_id, :permission_id, :target_meta_id
  context "测试方法" do
    setup do
      @limit_scope = Factory(:limit_scope, 
        :value_meta=>Factory(:meta, :klass => Factory(:klass)),
        :op=>'=', :logic => 'AND')
    end
    should "得到定义的sql语句" do
      assert_match(/users.name\s+?=\s+?users.name/, @limit_scope.to_condition)
      @limit_scope.value_meta = Factory(:var_meta, :klass=>Factory(:date_klass))
      assert_match(/users.name\s+?=.*?#{Date.today}/, @limit_scope.to_condition)
      @limit_scope.value_meta = nil
      @limit_scope.op = 'IN'
      @limit_scope.value = '1,2'
      assert_match(/users.name\s+?IN\s+?\(\s*?'1',\s*?'2'\s*?\)/, @limit_scope.to_condition)
      @limit_scope.op = 'between'
      assert_match(/users.name\s+?BETWEEN\s+?'1'\s+?AND\s+?'2'/, @limit_scope.to_condition)
    end
    should "可以连接limit_scopes" do
      @limit_scope2 = Factory(:limit_scope,
        :key_meta => Factory(:meta, :klass=>Factory(:klass), :key=>'state_id'),
        :value => 1, :op => '=')
      assert LimitScope.join_conditions([@limit_scope, @limit_scope2]),
        @limit_scope.to_condition << ' AND ' << @limit_scope2.to_condition
    end
  end
end
