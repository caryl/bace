require File.dirname(__FILE__) + '/../test_helper'

class LimitUsingTest < ActiveSupport::TestCase
  should_have_db_column :permissions_role_id
  should_have_db_column :limit_group_id

  should_belong_to :limit_group
  should_have_many :permissions_role
end
