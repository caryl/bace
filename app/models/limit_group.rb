# == Schema Information
# Schema version: 20091028135447
#
# Table name: limit_groups
#
#  id         :integer(4)      not null, primary key
#  klass_id   :integer(4)      
#  parent_id  :integer(4)      
#  lft        :integer(4)      
#  rgt        :integer(4)      
#  logic      :string(255)     
#  remark     :string(255)     
#  created_at :datetime        
#  updated_at :datetime        
#

class LimitGroup < ActiveRecord::Base
  acts_as_nested_set
  belongs_to :klass
  has_many :limit_scopes, :dependent => :destroy

  has_many :limit_usings, :dependent => :destroy
  has_many :permissions_roles, :through => :limit_usings

  def all_target_metas
    all_children_id = LimitGroup.unlimit_find(:all,
      :conditions => ['lft >= ? and rgt <= ?', self.lft, self.rgt], :order => 'lft desc').map(&:id)
    metas_id = LimitScope.unlimit_find(:all, :conditions=>{:limit_group_id=>all_children_id}).map(&:target_meta_id)
    Meta.unlimit_find(metas_id)
  end
  
  #caced_full_conditions
  def self.cached_full_scopes_conditions(groups)
    Rails.cache.fetch("full_scopes_conditions_#{groups.flatten.compact.map(&:id).join('_')}"){
      self.full_scopes_conditions(groups)
    }
  end

  def self.full_scopes_conditions(groups)
    scope = {}
    return scope if groups.blank?
    scope[:conditions] =
      groups.flatten(1).map do |role_groups|
      r = role_groups.flatten.compact.map{|cs|cs.join_conditions}.join(' AND ')
      r = "(#{r})" if r.present?
      r.blank? ? nil : r
    end.compact.join(' OR ')
    scope[:include] =
      groups.flatten.compact.map(&:all_target_metas).flatten.map(&:include).uniq.compact
    scope[:joins] =
      groups.flatten.compact.map(&:all_target_metas).flatten.map(&:joins).uniq.compact
    scope
  end
  
  def join_conditions
    scopes = LimitScope.unlimit_find(:all,:conditions=>{:limit_group_id => self})
    direct_children = LimitGroup.unlimit_find(:all,:conditions=>{:parent_id => self})
    '(' << (scopes.map(&:to_condition) | direct_children.map{|c|c.join_conditions}).compact.join(" #{self.logic} ") << ')'
  end

  #check
  def self.full_checks(groups)
    groups ||= []
    result =
      groups.flatten(1).map do |role_groups|
      r = role_groups.flatten.compact.map{|cs|cs.join_checks}.join(' and ')
      r = "(#{r})" if r.present?
      r.blank? ? nil : r
    end.compact.join(' or ')
    result.present? ? result : 'true'
  end

  def join_checks
    scopes = LimitScope.unlimit_find(:all,:conditions=>{:limit_group_id => self})
    direct_children = LimitGroup.unlimit_find(:all,:conditions=>{:parent_id => self})
    '(' << (scopes.map(&:to_check) | direct_children.map{|c|c.join_checks}).compact.join(" #{self.logic.downcase} ") << ')'
  end

  #inspect
  def self.full_inspects(groups)
    groups.flatten(1).map do |role_groups|
      #flatten(1) ruby 1.8.6不支持
      #r = role_groups.inject{|s,i| s = s + i.to_a}
      r = role_groups.flatten.compact.map{|cs|cs.join_inspects}.join(' 并且 ')
      r = "(#{r})" if r.present?
      r.blank? ? nil : r
    end.compact.join(' 或者 ')
  end

  def join_inspects
    scopes = LimitScope.unlimit_find(:all,:conditions=>{:limit_group_id => self})
    direct_children = LimitGroup.unlimit_find(:all,:conditions=>{:parent_id => self})
    '(' << (scopes.map(&:to_inspect) | direct_children.map{|c|c.join_inspects}).join(" #{self.logic} ") << ')'
  end
end
