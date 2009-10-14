class SessionController < ApplicationController
  skip_before_filter :check_allow
  def login
    return unless request.post?
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      redirect_back_or_default(users_path)
      flash.now[:notice] = "成功登录"
    else
      flash.now[:error] = "用户名或密码错误."
    end
  end

  def logout
    cookies.delete :login_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/')
  end

end
