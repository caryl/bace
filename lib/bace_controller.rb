module BaceController
  def self.included(base)
    base.send(:include, InstanceMethods)
    base.send :prepend_before_filter, :check_allow
    base.send :prepend_before_filter,  :set_current
    base.send(:include, AuthenticatedSystem)
    base.send(:include, DynamicSearch)
    base.send(:include, AlwaysPublic)
    base.send(:include, AlwaysFree)
    base.send :helper, :menus
    base.extend ClassMethods
  end

  module ClassMethods
    def always_public?(action)
      self.respond_to?(:always_public_actions) && (self.always_public_actions & [action.to_sym, :all]).present?
    end

    def always_free?(action)
      self.respond_to?(:always_free_actions) && (self.always_free_actions & [action.to_sym, :all]).present?
    end
  end

  module InstanceMethods
    def set_current
      Current.user_proc = proc{current_user}
      Current.controller_proc = proc{self}
    end

    def check_allow
      return true if is_allow?
      flash[:error] = '你没有权限访问这个功能.'
      redirect_to login_path
    end

    def is_allow?
      return true if self.always_public?
      return false unless current_user && current_user.cached_can_do_resource?(controller_name, action_name)
      limits = Current.user.cached_limits_for_resource(Current, controller_name, action_name) if Current.user_proc
      full_check = LimitGroup.full_checks(limits)
      logger.debug("::BACE DEBUG:: action scope checks on #{controller_name}-#{action_name}: #{full_check}" )
      return false unless self.instance_eval(full_check)
      true
    end

    def always_public?
      self.class.always_public?(action_name)
    end
    
    def always_free?
      self.class.always_free?(action_name)
    end
  end
end
