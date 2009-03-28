require File.dirname(__FILE__) + '/../test_helper'

class PermissionsMetaTest < ActiveSupport::TestCase
  should_have_db_column :target_id
  should_have_db_column :permission_id
  should_have_db_column :meta_id
  should_have_db_column :include
  should_have_db_column :joins

  should_belong_to :permission
  should_belong_to :meta
  should_belong_to :target
end
