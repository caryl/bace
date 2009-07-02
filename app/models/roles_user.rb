# == Schema Information
# Schema version: 20090702173749
#
# Table name: roles_users
#
#  id         :integer(4)      not null, primary key
#  role_id    :integer(4)      
#  user_id    :integer(4)      
#  created_at :datetime        
#  updated_at :datetime        
#

class RolesUser < ActiveRecord::Base

  belongs_to :user
  belongs_to :role
end
