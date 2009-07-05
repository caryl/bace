require File.dirname(__FILE__) + '/../test_helper'

class LimitScopeTest < ActiveSupport::TestCase
  def setup
    @limit_scope = Factory(:limit_scope)
  end
  should_have_db_column :target_meta_id
  should_have_db_column :target_klass_id
  should_have_db_column :key_meta_id
  should_have_db_column :op
  should_have_db_column :value_meta_id
  should_have_db_column :value
  should_have_db_column :position
 
  should_belong_to :key_meta
  should_belong_to :value_meta
  should_belong_to :target_meta
  should_belong_to :target_klass

  should_have_instance_methods :to_condition, :to_check, :to_inspect
  should_validate_presence_of :target_meta_id
  context "测试方法" do
    setup do
      @limit_scope = Factory(:limit_scope, 
        :value_meta=>Factory(:meta, :klass => Factory(:klass)),
        :op=>'=')
    end
    should "将scope转换为condition或check条件" do
      assert_match(/users.name\s+?=\s+?users.name/, @limit_scope.to_condition)
      assert_match(/self.name\s+?==\s+?self.name/, @limit_scope.to_check)
      assert_match(/用户.*?等于\s+?用户.*?/, @limit_scope.to_inspect)
      @limit_scope.value_meta = Factory(:var_meta, :klass=>Factory(:date_klass))
      assert_match(/users.name\s+?=.*?#{Date.today}/, @limit_scope.to_condition)
      assert_match(/self.name\s+?==.*?Date.today/, @limit_scope.to_check)
      assert_match(/用户.*?等于\s+?Date.Today*?/, @limit_scope.to_inspect)
      @limit_scope.value_meta = nil
      @limit_scope.op = 'IN'
      @limit_scope.value = '1,2'
      assert_match(/users.name\s+?IN\s+?\(\s*?'1',\s*?'2'\s*?\)/, @limit_scope.to_condition)
      assert_match(/\[\s*?'1',\s*?'2'\s*?\].include\?\(self.name\)/, @limit_scope.to_check)
      assert_match(/用户.*?包含于\s+?'1,2'*?/, @limit_scope.to_inspect)
      @limit_scope.op = 'between'
      assert_match(/users.name\s+?BETWEEN\s+?'1'\s+?AND\s+?'2'/, @limit_scope.to_condition)
      assert_match(/self.name\s+?\>\=\s+?\['1','2'\].first && self.name\s+?\<\=\s+?\['1','2'\].second/, @limit_scope.to_check)
      assert_match(/用户\..*?介于\s+?'1,2'/, @limit_scope.to_inspect)
    end
  end
end
