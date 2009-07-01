class PermissionsRole < ActiveRecord::Base
  belongs_to :permission
  belongs_to :role
  
  belongs_to :record_limit, :class_name => 'LimitGroup'
  belongs_to :context_limit, :class_name => 'LimitGroup'
end
