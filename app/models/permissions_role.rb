# == Schema Information
# Schema version: 20091028135447
#
# Table name: permissions_roles
#
#  id            :integer(4)      not null, primary key
#  permission_id :integer(4)      
#  role_id       :integer(4)      
#  granted       :boolean(1)      
#  created_at    :datetime        
#  updated_at    :datetime        
#

class PermissionsRole < ActiveRecord::Base
  belongs_to :permission
  belongs_to :role

  has_many :limit_usings, :dependent => :destroy
  has_many :limit_groups, :through => :limit_usings
end
