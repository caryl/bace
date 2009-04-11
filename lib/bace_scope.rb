module BaceScope
  def self.included(base)
    base.class_eval do
      extend ClassMethods
      self.send(:include, InstanceMethods)
      alias_method_chain :validate, :bace
      class << self
        alias_method_chain :find, :bace
      end
    end
  end

  module ClassMethods
    def find_with_bace(*args)
      scopes = Current.user.scopes_for_resource(self, Current.controller_name, Current.action_name) if Current.user_proc
      if scopes.present?
        with_scope(:find => LimitScope.full_scops_conditions(scopes)) do
          find_without_bace( *args )
        end
      else
        find_without_bace(*args)
      end
    end
  end

  module InstanceMethods
    def validate_with_bace
      scopes = Current.user.scopes_for_resource(self.class, Current.controller_name, Current.action_name) if Current.user_proc
      self.errors.add_to_base("你没有权限保存该数据，请检查：#{LimitScope.full_inspects(scopes)}") unless self.instance_eval(LimitScope.full_checks(scopes))
      validate_without_bace
    end
  end
end