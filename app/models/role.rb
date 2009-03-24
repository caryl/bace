class Role < ActiveRecord::Base
  acts_as_nested_set

  has_many :roles_users, :dependent => :destroy
  has_many :users, :through => :roles_users

  has_many :permissions_roles, :dependent => :destroy
  has_many :permissions, :through => :permissions_roles
  
  has_many :limit_scopes

  validates_uniqueness_of :name

  def has_permission?(permission)
    permission = Permission.find(permission) if permission.is_a?(Integer)
    self_and_ancestors.reverse.each do |role|
      granted =  role.self_has_permission?(permission)
      return granted unless granted.nil?
    end
    nil
  end

  def self_has_permission?(permission)
    permission = Permission.find(permission) if permission.is_a?(Integer)
    return true if permission.can_public?
    permission.self_and_ancestors.reverse.each do |p|
      granted = p.granted_to_role?(self)
      return granted unless granted.nil?
    end
    nil
  end
  
  def can_do_resource?(controller, action)
    resource = Resource.find_by_controller_and_action(controller, action)
    has_permission?(resource.permission) if resource
  end

  #角色定义的scope
  def scopes_for_permission(target, permission)
    ancestors_and_role = Role.unlimit_find(:all,
      :conditions => ['lft <= ? and rgt >= ?', self.lft, self.rgt], :order => 'lft desc')
    ancestors_and_role.map{|r|r.self_scopes_for_permission(target, permission)}
  end

  def self_scopes_for_permission(target, permission)
    permission = Permission.unlimit_find(permission) if permission.is_a?(Integer)
    return [] if permission.can_free?
    #得到ancestors and permission
    ancestors_and_permission = Permission.unlimit_find(:all, 
      :conditions => ['lft <= ? and rgt >= ?', permission.lft, permission.rgt], :order => 'lft desc')
    ancestors_and_permission.map{|p|p.scopes_to_role(target, self)}
  end

  def method_missing(method_name, *args)
    if match = /^can_(\w+?)_(\w+?)\?$/.match(method_name.to_s)
      #TODO:也有单数形式的controller...
      return can_do_resource?(match[2].pluralize, match[1])
    else
      super
    end
  end
end

