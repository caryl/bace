module BaceMagicColumn
  def self.included(base)
    base.send :include, InstanceMethods
    base.send :before_create, :auto_add_creator
  end

  module InstanceMethods
    def auto_add_creator
      self.creator_id ||= Current.user.id if self.respond_to?(:created_id=)
    end
  end
end
