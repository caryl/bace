class PermissionMeta < ActiveRecord::Base
  belongs_to :permission
  belongs_to :meta
end
