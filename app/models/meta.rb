# == Schema Information
# Schema version: 20090702173749
#
# Table name: metas
#
#  id             :integer(4)      not null, primary key
#  klass_id       :integer(4)      
#  key            :string(255)     
#  name           :string(255)     
#  kind_id        :integer(4)      
#  assoc_klass_id :integer(4)      
#  include        :string(255)     
#  joins          :string(255)     
#  renderer       :string(255)     
#  editor         :string(255)     
#  created_at     :datetime        
#  updated_at     :datetime        
#

class Meta < ActiveRecord::Base
  belongs_to :klass
  belongs_to :assoc_klass, :class_name => 'Klass'
  validates_presence_of :klass, :key, :kind_id
  KINDS = [['FIELD',1],['VAR',2]]

  named_scope :kind_of, lambda{|kind|{:conditions => {:kind_id => KINDS.assoc(kind).second}}}
  
  def kind
    define = KINDS.detect{|k|k.second == self.kind_id}
    define.first if define
  end

  #返回class
  def get_class
    self.klass.get_class
  end

  def human_name
    klass = Klass.unlimit_find(:first, :conditions => {:id => self.klass_id})
    "#{klass.human_name }.#{self.name}"
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
