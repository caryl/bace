require File.dirname(__FILE__) + '/../test_helper'

class MetaTest < ActiveSupport::TestCase
  def setup
    @meta = Factory(:meta, :klass=>Factory(:klass))
  end
  should_have_db_column :klass_id
  should_have_db_column :key
  should_have_db_column :name
  should_have_db_column :assoc_klass_id
  should_have_db_column :include
  should_have_db_column :joins
  
  should_belong_to :klass
  should_belong_to :assoc_klass

  should_validate_presence_of :klass, :key
  should_have_instance_methods :get_class, :get_type, :var_value

  context "测试方法" do
    setup do 
      @meta = Factory(:meta)
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
      @meta.klass = Factory(:date_klass)
      @meta.key = 'today'
      assert_nil @meta.var_value
      assert @meta.var_value, Date.today
      @meta.key = 'today.day'
      assert @meta.var_value, Date.today.day
    end
  end
end