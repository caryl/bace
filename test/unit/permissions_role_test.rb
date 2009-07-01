require File.dirname(__FILE__) + '/../test_helper'

class PermissionsRoleTest < ActiveSupport::TestCase
  should_have_db_column :permission_id
  should_have_db_column :role_id
  should_have_db_column :granted
  should_have_db_column :record_limit_id
  should_have_db_column :context_limit_id

  should_belong_to :permission
  should_belong_to :role
  should_belong_to :record_limit
  should_belong_to :context_limit
end
