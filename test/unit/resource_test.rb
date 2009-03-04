require File.dirname(__FILE__) + '/../test_helper'

class ResourceTest < ActiveSupport::TestCase
  def setup
    @resource = Factory(:resource)
  end
  should_have_db_column :name
  should_have_db_column :controller
  should_have_db_column :action
  should_have_db_column :permission_id

  should_belong_to :permission
end
