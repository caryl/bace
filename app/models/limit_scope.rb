class LimitScope < ActiveRecord::Base
  belongs_to :role
  belongs_to :permission
  belongs_to :key_meta, :class_name => 'Meta'
  belongs_to :value_meta, :class_name => 'Meta'

  OPS = [['=', '='],['>', '>']]

  named_scope :for_role, lambda{|role|{:conditions => {:role_id => role}}}
  named_scope :for_permission, lambda{|permission|{:conditions => {:permission_id => permission}}}

  def to_condition
    unlimit_key_meta = Meta.find_without_bace(:first, :conditions => {:id => self.key_meta_id})
    {unlimit_key_meta.obj.capitalize.constantize.table_name + '.' + unlimit_key_meta.key => value}
  end
end
