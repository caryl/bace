# == Schema Information
# Schema version: 20091028135447
#
# Table name: permissions
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)     
#  parent_id  :integer(4)      
#  lft        :integer(4)      
#  rgt        :integer(4)      
#  remark     :string(255)     
#  public     :boolean(1)      
#  free       :boolean(1)      
#  created_at :datetime        
#  updated_at :datetime        
#

class Permission < ActiveRecord::Base
  acts_as_nested_set
  
  has_many :permissions_roles, :dependent => :destroy
  has_many :roles, :through => :permissions_roles
  has_many :resources

  has_many :limit_scopes

  has_many :klasses_permissions, :dependent => :destroy
  has_many :klasses, :through => :klasses_permissions

  validates_uniqueness_of :name

  #是否不需要功能级限制
  def can_public?
    ancestors_and_permission = Permission.unlimit_find(:all,
      :conditions => ['lft <= ? and rgt >= ?', self.lft, self.rgt], :order => 'lft desc')
    permission = ancestors_and_permission.detect{|p|!p.public.nil?}
    permission.try :public
  end

  #是否对某角色授权，不继承
  def granted_to_role?(role)
    result = permissions_roles.unlimit_find(:first, :conditions=>{:role_id => role})
    result.granted if result
  end

  def limits_to_role(target, role)
    role_permission = PermissionsRole.unlimit_find(:first,:conditions => {:permission_id=> self,:role_id=>role})
    return nil unless role_permission
    groups = role_permission.limit_groups.unlimit_find(:all, :conditions=>{:klass_id => target})
    groups.blank? ? nil : groups
  end

  #是否不需要scope限制
  def can_free?
    ancestors_and_permission = Permission.unlimit_find(:all,
      :conditions => ['lft <= ? and rgt >= ?', self.lft, self.rgt], :order => 'lft desc')
    permission = ancestors_and_permission.detect{|p|!p.free.nil?}
    permission.try :free
  end
end
