module Extend::User
  def self.included(base)
    base.extend(ClassMethods)
    base.send :include, InstanceMethods
  end

  module ClassMethods

  end

  module InstanceMethods

  end
end