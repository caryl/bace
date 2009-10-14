module AuthenticatedSystem
  protected
  def logged_in?
    current_user
  end

  def logged_in!(user)
    self.current_user = user
  end

  def current_user
    @current_user ||= (login_from_session || login_from_basic_auth || login_from_cookie )
  end

  def remember_token!
      cookies[:login_token] = { :value => Encryption.encrypt(current_user.user_name) + ';' + current_user.id.to_s,
        :expires => 12.years.from_now }
  end

  def current_user=(new_user)
    session[:user_id] = (new_user.nil? || new_user.is_a?(Symbol)) ? nil : new_user.id
    @current_user = new_user
  end

  def authorized?
    logged_in?
  end

  def login_required
    return if authorized?
    redirect_to login_path
  end

  def store_location
    session[:return_to] = request.request_uri
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def self.included(base)
    base.send :helper_method, :current_user, :logged_in?
  end

  def login_from_session
    self.current_user = User.unlimit_find(session[:user_id]) if session[:user_id]
  end

  def login_from_basic_auth
    authenticate_with_http_basic do |login, password|
      self.current_user = User.authenticate(login, password)
    end
  end

  def login_from_cookie
    if cookies[:login_token]
      encrypted_token, user_id = cookies[:login_token].split(';')
      user = User.unlimit_find(:first, :conditions => {:id => user_id.to_i})
      if user && encrypted_token == Encryption.encrypt(user.user_name)
        self.current_user = user
      else
        cookies.delete :login_token
        return nil
      end
    end
  end
end
