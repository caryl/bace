module BaceController
  def self.included(base)
    base.send(:include, InstanceMethods)
    base.send :prepend_before_filter, :check_allow
    base.send :prepend_before_filter,  :set_current
    base.send(:include, AuthenticatedSystem)
    base.send(:include, BaceDynamicSearch)
    base.send(:include, BaceControllerExclude)
    base.send :helper, :menus
    base.send :helper, :bace
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
  end
end