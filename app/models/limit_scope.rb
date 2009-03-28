class LimitScope < ActiveRecord::Base
  belongs_to :role
  belongs_to :permission
  belongs_to :target_meta, :class_name => 'Meta'
  belongs_to :target_klass, :class_name => 'Klass'
  belongs_to :key_meta, :class_name => 'Meta'
  belongs_to :value_meta, :class_name => 'Meta'


  validates_presence_of :role_id, :permission_id, :target_meta_id

  OPS = [['等于', '='],['大于', '>'],['大于等于', '>='],
    ['小于', '<'],['小于等于', '<='],['不等于', '<>'],
    ['开始于', 'BEGINWITH'],['结束于', 'ENDWITH'],
    ['约等于', 'LIKE'],['包含于', 'IN'],
    ['不包含于','NOT IN'], ['为空', 'IS NULL']]

  named_scope :for_role, lambda{|role|{:conditions => {:role_id => role}}}
  named_scope :for_permission, lambda{|permission|{:conditions => {:permission_id => permission}}}

  #保存以前，判断是否存在target_klass,不存在取target_meta.klass
  #如果key_meta为空或key_meta.klass = target_meta.klass，取target_meta
  def before_save
    return unless self.target_meta
    self.target_klass = self.target_meta.klass
    self.key_meta = self.target_meta if self.key_meta.nil? || self.target_meta.assoc_klass.nil?
  end

  #TODO:本方法移动到lib
  def self.full_scops_conditions(scopes)
    limit_scopes = {}
    limit_scopes[:conditions] = 
      scopes.map do |role_conditions|
        result = role_conditions.flatten(1).compact.map{|cs|join_conditions(cs)}.join(' AND ')
        result = "(#{result})" if result.present?
        result
      end.compact.join(' OR ')
    limit_scopes[:include] = scopes.flatten.compact.map{|s|s.target_meta.include if s.target_meta}.uniq.compact
    limit_scopes[:joins] = scopes.flatten.compact.map{|s|s.target_meta.joins if s.target_meta}.uniq.compact
    limit_scopes
  end

  def self.join_conditions(limit_scopes)
    limit_scopes = limit_scopes.map{|c|[c.to_condition, c.logic]}.flatten
    limit_scopes.delete_at(-1)
    limit_scopes.join(' ')
  end

  def to_condition
    unlimit_key_meta = Meta.unlimit_find(:first, :conditions => {:id => self.key_meta_id})
    key_meta_table = unlimit_key_meta.get_class.table_name
    unlimit_value_meta = Meta.unlimit_find(:first, :conditions => {:id => self.value_meta_id})
    if unlimit_value_meta && unlimit_value_meta.kind == 'FIELD'
      value_meta_table = unlimit_value_meta.get_class.table_name
      var_value = "#{value_meta_table}.#{unlimit_value_meta.key}"
      "#{self.prefix}#{key_meta_table}.#{unlimit_key_meta.key} #{self.op} #{var_value}#{self.suffix}"
    else
      #处理直接结果
      if unlimit_value_meta
        #如果是VAR计算出结果
        var_value = unlimit_value_meta.var_value if unlimit_value_meta.kind == 'VAR'
      else
        var_value = self.value
      end
      var_value = var_value.to_s.split(',')

      var_value =
        case unlimit_key_meta.get_type
      when :integer
        var_value.map(&:to_i)
      when :float
        var_value.map(&:to_f)
      else
        var_value
      end
    
      #根据op再处理
      spaceholder =
        case  self.op.upcase
      when 'BETWEEN'
        ["BETWEEN ? AND ?", *var_value]
      when 'IN', 'NOT IN'
        ["#{self.op} (?)", var_value]
      when 'LIKE'
        ["LIKE ?", "%#{var_value.first}%"]
      when 'BEGINWITH'
        ["LIKE ?", "#{var_value.first}%"]
      when 'ENDWITH'
        ["LIKE ?", "%#{var_value.first}"]
      when 'IS NULL'
        ["IS NULL"]
      else
        ["#{self.op} ?", *var_value]
      end
      spaceholder[0] = "#{key_meta_table}.#{unlimit_key_meta.key} " + spaceholder[0]
      "#{self.prefix}#{ActiveRecord::Base.send :sanitize_sql, spaceholder}#{self.suffix}"
    end
  end
  
end
