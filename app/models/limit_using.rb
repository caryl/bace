# == Schema Information
# Schema version: 20091028135447
#
# Table name: limit_usings
#
#  id                  :integer(4)      not null, primary key
#  permissions_role_id :integer(4)      
#  limit_group_id      :integer(4)      
#  created_at          :datetime        
#  updated_at          :datetime        
#

class LimitUsing < ActiveRecord::Base
  belongs_to :permissions_role
  belongs_to :limit_group
end
