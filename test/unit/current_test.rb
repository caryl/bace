require File.dirname(__FILE__) + '/../test_helper'

class CurrentTest < ActiveSupport::TestCase
  should_have_class_methods :user, :controller, :action,
    :user_proc, :user_proc=, :controller_proc, :controller_proc=, :action_proc, :action_proc=
end
