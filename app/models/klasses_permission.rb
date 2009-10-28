# == Schema Information
# Schema version: 20091028135447
#
# Table name: klasses_permissions
#
#  id            :integer(4)      not null, primary key
#  klass_id      :integer(4)      
#  permission_id :integer(4)      
#  created_at    :datetime        
#  updated_at    :datetime        
#

class KlassesPermission < ActiveRecord::Base
  belongs_to :klass
  belongs_to :permission
end
