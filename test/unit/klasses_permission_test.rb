require File.dirname(__FILE__) + '/../test_helper'

class KlassesPermissionTest < ActiveSupport::TestCase
  should_have_db_column :klass_id
  should_have_db_column :permission_id

  should_belong_to :klass
  should_belong_to :permission
end
