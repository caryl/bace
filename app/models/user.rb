class User < ActiveRecord::Base
  attr_accessor :new_password
  has_many :roles_users, :dependent => :destroy
  has_many :roles, :through => :roles_users

  validates_presence_of :login, :email
  validates_length_of :login, :within => 2..16
  validates_length_of :name, :within => 2..16
  validates_uniqueness_of :login
  validates_uniqueness_of :name
  validates_uniqueness_of :email, :allow_blank => true
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i

  def before_save
    self.password = Encryption.encrypt(@new_password) unless @new_password.blank?
  end

  def self.authenticate(login, password)
    u = unlimit_find(:first, :conditions => {:login => login})
    u && u.password_match?(password) ? u : nil
  end

  def password_match?(current_password)
    self.password == Encryption.encrypt(current_password)
  end

  def has_permission?(permission)
    permission = Permission.find(permission) if permission.is_a?(Integer)
    return true if permission.can_public?
    granteds = roles.map{|role|role.has_permission?(permission)}.compact
    return nil if granteds.blank?
    return granteds.include?(true)
  end

  def can_do_resource?(controller, action)
    resource = Resource.find_by_controller_and_action(controller, action)
    has_permission?(resource.permission) if resource
  end

  #TODO:同一个action期间，是否可以缓存到Current中?
  def scopes_for_resource(controller, action)
    resource = Resource.unlimit_find(:first, :conditions => {:controller => controller, :action => action})
    permission = Permission.unlimit_find(:first, :conditions =>{:id => resource.permission_id}) if resource
    permission ? scopes_for_permission(permission) : []
  end

  def scopes_for_permission(permission)
    return [] if permission.can_free?
    unlimit_roles = roles.unlimit_find(:all)
    unlimit_roles.map{|role|role.scopes_for_permission(permission)}
  end

  def method_missing(method_name, *args)
    if match = /^can_(\w+?)_(\w+?)\?$/.match(method_name.to_s)
      return can_do_resource?(match[2].pluralize, match[1])
    else
      super
    end
  end
end
