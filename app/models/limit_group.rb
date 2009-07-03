# == Schema Information
# Schema version: 20090702173749
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

  def all_scopes
    all_children_id = self.unlimit_find(:all,
      :conditions => ['lft > ? and rgt < ?', self.lft, self.rgt], :order => 'lft desc').map(&:id)
    LimitScope.unlimit_find(:all, :conditions=>{:limit_group_id=>all_children_id})
  end
  
  #find condition
  #caced_full_conditions
  def self.cached_full_scopes_conditions(groups)
    Rails.cache.fetch("full_scopes_conditions_#{groups.map(&:id).join('_')}"){
      self.full_scopes_conditions(groups)
    }
  end

  def self.full_scopes_conditions(groups)
    scope = {}
    return scope if groups.blank?
    scope[:conditions] =
      groups.map do |role_groups|
      #flatten(1) ruby 1.8.6不支持
      r = role_groups.inject{ |s,i| s = s + i.to_a }
      r = r.flatten.compact.map{|cs|cs.join_conditions}.join(' AND ')
      r = "(#{r})" if r.present?
      r.blank? ? nil : r
    end.compact.join(' OR ')
    scope[:include] =
      groups.flatten.compact.map(&:all_scopes).map{|s|s.target_meta.include if s.target_meta && s.target_meta.include.present?}.uniq.compact
    scope[:joins] =
      groups.flatten.compact.map(&:all_scopes).map{|s|s.target_meta.joins if s.target_meta && s.target_meta.joins.present?}.uniq.compact
    scope
  end
  
  def join_conditions
    scopes = LimitScope.unlimit_find(:all,:conditions=>{:limit_group_id => self})
    direct_children = LimitGroup.unlimit_find(:all,:conditions=>{:parent_id => self})
    '(' << (scopes.map(&:to_condition) | direct_children.map{|c|c.join_conditions}).join(" #{self.logic} ") << ')'
  end

  #check
  def self.full_checks(scopes)
    scopes ||= []
    result =
      scopes.map do |role_groups|
      #flatten(1) ruby 1.8.6不支持
      r = role_groups.inject{|s,i| s = s + i.to_a}
      r = r.compact.map{|cs|cs.join_checks}.join(' && ')
      r = "(#{r})" if r.present?
      r.blank? ? nil : r
    end.compact.join(' || ')
    result.present? ? result : 'true'
  end

  def join_checks
    scopes = LimitScope.unlimit_find(:all,:conditions=>{:limit_group_id => self})
    direct_children = LimitGroup.unlimit_find(:all,:conditions=>{:parent_id => self})
    '(' << (scopes.map(&:to_check) | direct_children.map{|c|c.join_checks}).join(" #{self.logic} ") << ')'
  end

  #inspect
  def self.full_inspects(scopes)
    scopes.map do |role_groups|
      #flatten(1) ruby 1.8.6不支持
      r = role_groups.inject{|s,i| s = s + i.to_a}
      r = r.compact.map{|cs|cs.join_inspects}.join(' 并且 ')
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
