class LimitScope < ActiveRecord::Base
  belongs_to :role
  belongs_to :permission
  belongs_to :key_meta, :class_name => 'Meta'
  belongs_to :value_meta, :class_name => 'Meta'

  OPS = [['等于', '='],['大于', '>'],['大于等于', '>='],
    ['小于', '<'],['小于等于', '<='],['不等于', '<>'],
    ['介于', 'BETWEEN'],['约等于', 'LIKE'],['包含于', 'IN'],
    ['不包含于','NOT IN'], ['为空', 'IS NULL']]

  named_scope :for_role, lambda{|role|{:conditions => {:role_id => role}}}
  named_scope :for_permission, lambda{|permission|{:conditions => {:permission_id => permission}}}

  #FIXME:sql 注入漏洞
  def self.join_conditions(conditions)
    conditions = conditions.map{|c|[c.to_condition, c.logic]}.flatten
    conditions.delete_at(-1)
    conditions.join(' ')
  end
  
  #TODO:本方法移动到lib
  def self.full_scops_conditions(conditions)
    conditions.map do |role_conditions|
      result = role_conditions.flatten.compact.join(' AND ')
      result = "(#{result})" if result.present?
      result
    end.compact.join(' OR ')
  end
  def to_condition
    unlimit_key_meta = Meta.unlimit_find(:first, :conditions => {:id => self.key_meta_id})
    key_meta_table = unlimit_key_meta.klass.constantize.table_name
    unlimit_value_meta = Meta.unlimit_find(:first, :conditions => {:id => self.value_meta_id})
    if unlimit_value_meta && unlimit_value_meta.kind == 'FIELD'
      value_meta_table = unlimit_value_meta.klass.constantize.table_name
      var_value = "#{value_meta_table}.#{unlimit_value_meta.key}"
    else
      #处理直接结果
      if unlimit_value_meta
        #如果是VAR计算出结果
        var_value = unlimit_value_meta.var_value if unlimit_value_meta.kind == 'VAR'
      else
        var_value = self.value
      end

      #根据类型转换,如果是string,text,date, datetime 添加引号
      if [:string, :text, :date, :datetime].include?(unlimit_key_meta.get_type)
        var_value = var_value.to_s.split(',').map{|v|"'#{v.strip}'"}.join(',')
      end
    
      #根据op再处理
      var_value =
        case  self.op
      when 'BETWEEN'
        var_value.split(',').join(' AND ')
      when 'IN', 'NOT IN'
        "(#{var_value})"
      when 'IS NULL'
        nil
      else
        var_value
      end
    end
    #return
    "#{self.prefix}#{key_meta_table}.#{unlimit_key_meta.key} #{self.op} #{var_value}#{self.suffix}"
  end
  
end
