class Permission < ActiveRecord::Base
  acts_as_nested_set
  
  has_many :permissions_roles, :dependent => :destroy
  has_many :roles, :through => :permissions_roles
  has_many :resources

  has_many :permission_metas
  has_many :metas, :through => :permission_metas

  has_many :limit_scope

  validates_uniqueness_of :name
  
  def can_public?
    p = self_and_ancestors.reverse.detect{|p|!p.public.nil?}
    p.public if p
  end

  def granted_to_role?(role)
    result = permissions_roles.find_by_role_id(role)
    result.granted if result
  end
end
