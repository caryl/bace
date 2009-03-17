class Meta < ActiveRecord::Base
  has_many :permissions_metas
  has_many :permissions, :through => :permissions_metas

  KINDS = [['FIELD',1],['VAR',2],['ACTION',3]]


  def kind
    define = KINDS.detect{|k|k.second == self.kind_id}
    define.first if define
  end

  #返回class
  def get_class
    self.klass.constantize
  end

  #返回数据类型
  def get_type
    get_class.columns_hash[self.key].type
  end

  def var_value
    return nil unless self.kind == 'VAR'
    result = get_class
    self.key.split('.').each do |meth|
      result = result.send(meth)
    end
    result
  end
end
