require File.dirname(__FILE__) + '/../test_helper'

class CurrentTest < ActiveSupport::TestCase
  should_have_class_methods :user, :controller, :controller_name, :action_name,
    :user_proc, :controller_proc, :controller_proc=
end
