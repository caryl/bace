# == Schema Information
# Schema version: 20090702173749
#
# Table name: limit_scopes
#
#  id              :integer(4)      not null, primary key
#  limit_group_id  :integer(4)      
#  target_meta_id  :integer(4)      
#  target_klass_id :integer(4)      
#  key_meta_id     :integer(4)      
#  op              :string(255)     
#  value_meta_id   :integer(4)      
#  value           :string(255)     
#  position        :integer(4)      
#  kind_id         :integer(4)      
#  created_at      :datetime        
#  updated_at      :datetime        
#

class LimitScope < ActiveRecord::Base
  belongs_to :limit_group
  belongs_to :target_meta, :class_name => 'Meta'
  belongs_to :target_klass, :class_name => 'Klass'
  belongs_to :key_meta, :class_name => 'Meta'
  belongs_to :value_meta, :class_name => 'Meta'

  validates_presence_of :target_meta_id

  OPS = [
          ['等于', '='],['大于', '>'],['大于等于', '>='],
          ['小于', '<'],['小于等于', '<='],['不等于', '<>'],
          ['开始于', 'BEGINWITH'],['结束于', 'ENDWITH'],['介于', 'BETWEEN'],
          ['约等于', 'LIKE'],['包含于', 'IN'],
          ['不包含于','NOT IN'], ['为空', 'IS NULL']
        ]

  #保存以前，判断是否存在target_klass,不存在取target_meta.klass
  #如果key_meta为空或key_meta.klass = target_meta.klass，取target_meta
  def before_save
    return unless self.target_meta
    self.target_klass = self.target_meta.klass
    self.key_meta = self.target_meta if self.key_meta.nil? || self.target_meta.assoc_klass.nil?
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
      spaceholder << nil unless spaceholder[1]
      "#{self.prefix}#{ActiveRecord::Base.send :sanitize_sql, spaceholder}#{self.suffix}"
    end
  end

  def to_check
    #TODO:can't support association models.
    return if self.target_meta_id != self.key_meta_id

    unlimit_target_meta = Meta.unlimit_find(:first, :conditions => {:id => self.target_meta_id})
    unlimit_target_klass = Klass.unlimit_find(:first, :conditions => {:id => self.target_klass_id})
    unlimit_value_meta = Meta.unlimit_find(:first, :conditions => {:id => self.value_meta_id})

    if unlimit_value_meta
      if unlimit_value_meta.kind == 'FIELD'
        var_value = "self.#{unlimit_value_meta.key}"
      else
        value_klass = Klass.unlimit_find(:first, :conditions => {:id => unlimit_value_meta.klass_id})
        var_value = "#{value_klass.name}.#{unlimit_value_meta.key}"
      end
    else
      var_value = self.value.split(',')
      var_value.each_with_index{|v,i| var_value[i] = "'#{v}'" unless [Fixnum, Float].include?(v.class)}
      var_value << "''" if var_value.blank?
    end

    if unlimit_target_meta.kind == 'FIELD'
      var_target = "self.#{unlimit_target_meta.key}"
    else
      var_target = "#{unlimit_target_klass.name}.#{unlimit_target_meta.key}"
    end

    check_string =
      case self.op.upcase
    when 'BETWEEN'
      "#{var_target} >= [#{var_value.join(',')}].first && #{var_target} <= [#{var_value.join(',')}].second"
    when 'IN'
      "[#{var_value.join(',')}].include?(#{var_target})"
    when 'NOT IN'
      "![#{var_value.join(',')}].include?(#{var_target})"
    when 'LIKE'
      "#{var_target}.include?(#{var_value})"
    when 'BEGINWITH'
      "#{var_target}.start_with?(#{var_value})"
    when 'ENDWITH'
      "#{var_target}.end_with?(#{var_value})"
    when 'IS NULL'
      "#{var_target}.nil?"
    when '<>'
      "#{var_target} != #{var_value}"
    when '='
      "#{var_target} == #{var_value}"
    else
      "#{var_target} #{self.op} #{var_value}"
    end

    "#{self.prefix}#{check_string}#{self.suffix}"
  end

  def to_inspect
    return '空' unless self.target_meta_id
    unlimit_key_meta = Meta.unlimit_find(:first, :conditions => {:id => self.target_meta_id})
    unlimit_value_meta = Meta.unlimit_find(:first, :conditions => {:id => self.value_meta_id})

    if unlimit_value_meta
      var_value = unlimit_value_meta.human_name if unlimit_value_meta.present?
    else
      var_value = "'#{self.value}'"
    end
    operator = OPS.rassoc(self.op.upcase).first

    "#{self.prefix}#{unlimit_key_meta.human_name} #{operator} #{var_value}#{self.suffix}"
  end
end
