require File.dirname(__FILE__) + '/../test_helper'

class MetaTest < ActiveSupport::TestCase
  def setup
    @meta = Factory(:meta)
  end
  should_have_db_column :klass
  should_have_db_column :key
  should_have_db_column :name
  should_have_db_column :kind_id
  
  should_have_many :permissions_metas
  should_have_many :permissions
  should_belong_to :klass

  should_validate_presence_of :klass, :key, :kind_id
  should_have_instance_methods :kind, :get_class, :get_type, :var_value

  context "测试方法" do
    setup do 
      @meta = Factory(:meta)
    end
    should "可以得到KIND类型" do
      @meta.kind_id = 1
      assert @meta.kind, 'FIELD'
      @meta.kind_id = 2
      assert @meta.kind, 'VAR'
      @meta.kind_id = 3
      assert @meta.kind, 'ACTION'
    end
    should "可以得到META的类" do
      assert @meta.get_class, User
    end

    should "可以得到meta的类型" do
      @meta.key = 'name'
      assert @meta.get_type, :string
      @meta.key = 'state_id'
      assert @meta.get_type, :integer
    end

    should "得到VAR的值" do
      @meta.klass = 'Date'
      @meta.key = 'today'
      assert_nil @meta.var_value
      @meta.kind_id = 2
      assert @meta.var_value, Date.today
      @meta.key = 'today.day'
      assert @meta.var_value, Date.today.day
    end
  end
end