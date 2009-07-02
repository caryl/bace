require File.dirname(__FILE__) + '/../test_helper'

class LimitGroupTest < ActiveSupport::TestCase
  def setup
    @limit_group = Factory(:limit_group)
  end
  should_have_db_column :klass_id
  should_have_db_column :parent_id
  should_have_db_column :lft
  should_have_db_column :rgt
  should_have_db_column :logic
  should_have_db_column :remark
  should_have_db_column :kind_id

  should_have_many :limit_scopes
  should_belong_to :klass
  should_have_many :limit_usings
  should_have_many :permissions_roles
  context "测试方法" do
    setup do
      @limit_scope = Factory(:limit_scope, :limit_group => @limit_group,
        :value_meta=>Factory(:meta, :klass => Factory(:klass)),
        :op=>'=')
      @limit_scope2 = Factory(:limit_scope, :limit_group => @limit_group,
        :key_meta => Factory(:meta, :klass=>Factory(:klass), :key=>'state_id'),
        :value => 1, :op => '=')
    end
    should "可以连接limit_scopes" do
      assert @limit_group.join_conditions, @limit_scope.to_condition << ' AND ' << @limit_scope2.to_condition
      assert @limit_group.join_checks, @limit_scope.to_check << ' && ' << @limit_scope2.to_check
    end
  end
end
