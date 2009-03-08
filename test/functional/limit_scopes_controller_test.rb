require File.dirname(__FILE__) + '/../test_helper'

class LimitScopesControllerTest < ActionController::TestCase

  def setup
    @limit_scope = Factory(:limit_scope)
  end

end
