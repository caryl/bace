require File.dirname(__FILE__) + '/../test_helper'

class KlassesControllerTest < ActionController::TestCase

  def setup
    @klass = Factory(:klass)
  end

  should_be_restful do |resource|
    resource.formats = [:html, :xml]
    resource.destroy.flash = nil
  end
end
