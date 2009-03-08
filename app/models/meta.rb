class Meta < ActiveRecord::Base
  has_many :permission_metas
  has_many :permissions, :through => :permission_metas

  KINDS = [['FIELD',1],['VAR',2],['ACTION',3]]


  def kind
    define = KINDS.detect{|k|k.second == self.kind_id}
    define.first if define
  end
end
