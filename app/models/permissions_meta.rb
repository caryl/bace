class PermissionsMeta < ActiveRecord::Base
  belongs_to :permission
  belongs_to :meta

  def before_create
    self.target = meta.get_class.name unless self.target
  end
end
