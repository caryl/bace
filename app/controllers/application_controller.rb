class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  prepend_before_filter :check_allow
  prepend_before_filter  :set_current

  include AuthenticatedSystem
  include DynamicSearch

  def set_current
    Current.user_proc = proc{current_user}
    Current.controller_proc = proc{self}
  end

  def check_allow
    return true if is_allow?
    flash[:error] = 'You are not been granted to visit this page.'
    redirect_to login_path
  end

  def is_allow?
    return false unless current_user && current_user.cached_can_do_resource?(controller_name, action_name)
    #其他限制：如ip，时间等
    scopes = Current.user.cached_scopes_for_resource(nil, controller_name, action_name) if Current.user_proc
    return false unless self.instance_eval(LimitScope.full_checks(scopes))
    true
  end
  
  protect_from_forgery # :secret => 'f6f1b454c715150aeb2da533584e9463'
end
