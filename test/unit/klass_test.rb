require File.dirname(__FILE__) + '/../test_helper'

class KlassTest < ActiveSupport::TestCase
  should_have_db_column :name
  should_have_db_column :remark
  should_have_db_column :position
  should_have_db_column :kind_id


  should_have_many :klasses_permissions
  should_have_many :permissions
  should_have_many :metas
  should_have_many :limit_groups
end
