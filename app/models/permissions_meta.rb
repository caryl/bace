class PermissionsMeta < ActiveRecord::Base
  belongs_to :permission
  belongs_to :meta

  belongs_to :target, :class_name => "Klass"

  def before_create
    self.target = meta.get_class.name unless self.target
  end
end
