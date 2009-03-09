require File.dirname(__FILE__) + '/../test_helper'

class MetaTest < ActiveSupport::TestCase
  should_have_db_column :obj
  should_have_db_column :key
  should_have_db_column :name
  should_have_db_column :kind_id
  
  should_have_many :permission_metas
  should_have_many :permissions
end
