class Permission < ActiveRecord::Base
  acts_as_nested_set
  
  has_many :permissions_roles, :dependent => :destroy
  has_many :roles, :through => :permissions_roles
  has_many :resources

  has_many :permissions_metas, :dependent => :destroy
  has_many :metas, :through => :permissions_metas

  has_many :limit_scopes

  validates_uniqueness_of :name

  #是否不需要功能级限制
  def can_public?
    p = self_and_ancestors.reverse.detect{|p|!p.public.nil?}
    p.public if p
  end

  #是否对某角色授权，不继承
  def granted_to_role?(role)
    result = permissions_roles.find_by_role_id(role)
    result.granted if result
  end

  def scopes_to_role(role)
    conditions = limit_scopes.unlimit_find(:all, :conditions => {:role_id => role}, :order => 'position')
    return nil if conditions.blank?
    LimitScope.join_conditions(conditions)
  end

  #是否不需要scope限制
  def can_free?
    ancestors_and_permission = Permission.unlimit_find(:all,
      :conditions => ['lft <= ? and rgt >= ?', self.lft, self.rgt], :order => 'lft desc')
    p = ancestors_and_permission.reverse.detect{|p|!p.free.nil?}
    p.free if p
  end
end
