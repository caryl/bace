require File.dirname(__FILE__) + '/../test_helper'

class MenuTest < ActiveSupport::TestCase
  should_have_db_column :name
  should_have_db_column :permission_id
  should_have_db_column :parent_id
  should_have_db_column :lft
  should_have_db_column :rgt
  should_have_db_column :icon
  should_have_db_column :url
  should_have_db_column :remark

  should_belong_to :permission
  should_have_instance_methods :parent, :children, :visible, :visible=
end
