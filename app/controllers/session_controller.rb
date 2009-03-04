class SessionController < ApplicationController
  skip_before_filter :is_allow?
  def login
    return unless request.post?
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      redirect_back_or_default(users_path)
      flash.now[:notice] = "Logged in successfully"
    else
      flash.now[:error] = "Login authentication failed."
    end
  end

  def logout
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/')
  end

end
