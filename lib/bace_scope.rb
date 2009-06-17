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
      if Current.user_proc && Current.controller_proc #for test
        scopes = Current.user.cached_scopes_for_resource(self, Current.controller_name, Current.action_name)
        find_scope = LimitScope.cached_full_scopes_conditions(scopes)
        #dynamic_search
        #TODO:重构，把动态查询部分代码重构
        if Current.controller.params[:dynamic_search_model] == self
          dynamic_condition = Current.controller.params[:dynamic_search].to_condition
          if dynamic_condition.present?
            dynamic_condition = ' and ' + dynamic_condition if find_scope[:conditions].present?
            find_scope[:conditions] ||= ''
            find_scope[:conditions] += dynamic_condition
          end
        end
      end
      if scopes.present? || dynamic_condition.present?
        logger.debug("::BACE DEBUG:: find limit scope on #{self.name}: #{find_scope.inspect}" )
        with_scope(:find => find_scope) do
          find_without_bace( *args )
        end
      else
        find_without_bace(*args)
      end
    end
  end

  module InstanceMethods
    #保存是验证权限
    def validate_with_bace
      return unless Current.user_proc #unit test it.
      validate_method_name = "can_#{Current.action_name}_#{Current.controller_name}_with?"
      Current.user.send(validate_method_name, self)
      validate_without_bace
    end
  end
end

