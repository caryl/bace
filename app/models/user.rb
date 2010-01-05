# == Schema Information
# Schema version: 20091028135447
#
# Table name: users
#
#  id         :integer(4)      not null, primary key
#  login_name :string(255)
#  password   :string(255)     
#  user_name  :string(255)
#  email      :string(255)     
#  remark     :string(255)     
#  state_id   :integer(4)      
#  created_at :datetime        
#  updated_at :datetime        
#

class User < ActiveRecord::Base
  include Extend::User
  attr_accessor :new_password
  has_many :roles_users, :dependent => :destroy
  has_many :roles, :through => :roles_users

  validates_presence_of :login_name, :email
  validates_length_of :login_name, :within => 2..16
  validates_length_of :user_name, :within => 2..16
  validates_uniqueness_of :login_name
  validates_uniqueness_of :user_name
  validates_uniqueness_of :email, :allow_blank => true
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i

  def name
    user_name
  end

  def super_admin?
    self.login_name == 'admin'
  end

  def before_save
    self.password = Encryption.encrypt(@new_password) unless @new_password.blank?
  end

  def self.authenticate(login_name, password)
    u = unlimit_find(:first, :conditions => {:login_name => login_name})
    u && u.password_match?(password) ? u : nil
  end

  def password_match?(current_password)
    self.password == Encryption.encrypt(current_password)
  end

  def has_permission?(permission)
    permission = Permission.unlimit_find(permission) if permission.is_a?(Integer)
    return nil if permission.nil?
    return true if permission.can_public?
    granteds = roles.unlimit_find(:all).map{|role|role.has_permission?(permission)}.compact
    return nil if granteds.blank?
    return granteds.include?(true)
  end

  #action
  def can_do_resource?(controller, action)
    return true if Current.user.super_admin?
    resource = Resource.unlimit_find(:first, :conditions => {:controller => controller, :action => action})
    permission = Permission.unlimit_find(:first, :conditions =>{:id => resource.permission_id}) if resource
    has_permission?(permission) if permission
  end

  #某一entry在action中是否有权限
  def can_do_resource_with?(controller, action, entry)
    return true if Current.user.super_admin?
    groups = self.cached_limits_for_resource(entry.class, controller, action)
    full_check = LimitGroup.full_checks(groups)
    logger.debug("::BACE DEBUG:: dynamic validate on #{entry.class.name}: #{full_check}" )
    result = entry.instance_eval(full_check)
    entry.errors.add_to_base("没有权限操作该数据，请检查：#{LimitScope.full_inspects(groups)}") unless result
    return result
  end

  def limits_for_permission(target, permission)
    return [] if permission.can_free?
    unlimit_roles = roles.unlimit_find(:all)
    unlimit_roles.map{|role|role.limits_for_permission(target, permission)}
  end

  #scopes
  def limits_for_resource(target, controller, action)
#    return [] if Current.user.super_admin?
    target = Klass.unlimit_find(:first, :conditions => {:name => target.name}) if target.is_a?(Class)
    resource = Resource.unlimit_find(:first, :conditions => {:controller => controller, :action => action})
    permission = Permission.unlimit_find(:first, :conditions =>{:id => resource.permission_id}) if resource
    permission ? limits_for_permission(target, permission) : []
  end

  #menus
  def granted_menus
    menus = Menu.unlimit_find(:all, :order=>'lft')
    menus.reverse!.each do |menu|
      next if menu.visible
      #上次菜单可见
      menus.each{|m|m.visible = true if m.lft <= menu.lft && m.rgt >= menu.rgt} if self.has_permission?(menu.permission) || self.super_admin?
    end
    return menus.reverse!.select(&:visible)
  end

  #cached
  def cached_can_do_resource?(controller, action)
    Rails.cache.fetch("action_#{self.id}_#{controller}_#{action}"){
      can_do_resource?(controller, action)
    }
  end
  
  #cached
  def cached_limits_for_resource(target, controller, action)
    Rails.cache.fetch("scope_#{self.id}_#{target.name}_#{controller}_#{action}"){
      limits_for_resource(target, controller, action)
    }
  end

  #cached
  def cached_granted_menus
    Rails.cache.fetch("menus_#{self.id}"){
      granted_menus
    }
  end

  #can_{action}_{controller}?
  #can_{action}_{controller}_with?(object)
  def method_missing(method_name, *args)
    if match = /^can_(\w+?)_(\w+?)_with\?$/.match(method_name.to_s)
      return can_do_resource_with?(match[2].pluralize, match[1], args.first)
    elsif match = /^can_(\w+?)_(\w+?)\?$/.match(method_name.to_s)
      return cached_can_do_resource?(match[2].pluralize, match[1])
    else
      super
    end
  end
end
