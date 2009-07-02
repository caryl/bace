require File.dirname(__FILE__) + '/../test_helper'

class LimitGroupTest < ActiveSupport::TestCase
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

end
