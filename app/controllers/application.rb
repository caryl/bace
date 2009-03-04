class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  prepend_before_filter  :set_current
  prepend_before_filter :is_allow?

  include AuthenticatedSystem

  def set_current
    Current.user_proc = proc {current_user}
    Current.controller_proc = proc{controller_name}
    Current.action_proc = proc{action_name}
  end

  def is_allow?
    return true if current_user && current_user.can_do_resource?(controller_name, action_name)
    flash[:error] = 'You are not been granted to visit this page.'
    redirect_to login_path
  end
  
  protect_from_forgery # :secret => 'f6f1b454c715150aeb2da533584e9463'
end
