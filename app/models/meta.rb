class Meta < ActiveRecord::Base
  belongs_to :klass
  belongs_to :assoc_klass, :class_name => 'Klass'
  validates_presence_of :klass, :key, :kind_id
  KINDS = [['FIELD',1],['VAR',2],['ACTION',3]]

  named_scope :kind_of, lambda{|kind|{:conditions => {:kind_id => KINDS.assoc(kind).second}}}
  
  def kind
    define = KINDS.detect{|k|k.second == self.kind_id}
    define.first if define
  end

  #返回class
  def get_class
    self.klass.get_class
  end

  #返回数据类型
  def get_type
    get_class.columns_hash[self.key].type
  end

  def var_value
    return nil unless self.kind == 'VAR'
    get_class.class_eval(self.key)
  end

  def self.rebuild!
    klasses = Klass.all
    exclude_columns = [:created_at, :updated_at]
    klasses.each do |klass|
      model = klass.get_class
      next unless model.respond_to?('column_names')
      metas = []
      (model.column_names - exclude_columns).each do |column|
        metas << (klass.metas.find_by_key(column) ||
          klass.metas.create(:key=>column, 
          :name => column,
          :kind_id =>1))
      end
      (klass.metas - metas).each {|meta|meta.destroy unless model.new.respond_to?(meta.key)}
    end
  end

end
