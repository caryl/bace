class KlassesPermission < ActiveRecord::Base
  belongs_to :klass
  belongs_to :permission
end
