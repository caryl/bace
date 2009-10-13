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
    #重新定义find方法，在查询前加入权限条件
    def find_with_bace(*args)
      if Current.user_proc && Current.controller_proc #for unit test
        scopes = Current.user.cached_limits_for_resource(self, Current.controller_name, Current.action_name)
        find_scope = LimitGroup.cached_full_scopes_conditions(scopes).dup
        #dynamic_search
        find_scope = BaceUtils.append_dynamic_search(find_scope, Current.controller.params)
      end
      if find_scope.present?
        logger.debug("::BACE DEBUG:: find limit scope on #{self.name}: #{find_scope.inspect}" )
        with_scope(:find => find_scope) do
          find_without_bace( *args )
        end
      else
        find_without_bace(*args)
      end
    end

    def unlimit_find(*args)
      if self.respond_to?(:find_with_bace)
        find_without_bace(*args)
      else
        find(*args)
      end
    end
  end

  module InstanceMethods
    #保存是验证权限
    def validate_with_bace
      validate_without_bace
      return unless Current.user_proc #for unit test
      Current.user.can_do_resource_with?(Current.controller_name,Current.action_name,self)
    end
  end
end

