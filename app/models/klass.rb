# == Schema Information
# Schema version: 20090702173749
#
# Table name: klasses
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)     
#  remark     :string(255)     
#  position   :integer(4)      
#  kind_id    :integer(4)      
#  created_at :datetime        
#  updated_at :datetime        
#

class Klass < ActiveRecord::Base
  has_many :klasses_permissions, :dependent => :destroy
  has_many :permissions, :through => :klasses_permissions
  has_many :limit_groups, :dependent => :destroy
  has_many :metas
  
  KINDS = {'RECORD' => 1, 'CONTEXT' => 2}

  def kind
    define = KINDS.detect{|k|k.second == self.kind_id}
    define.first if define
  end

  def self.context
    self.unlimit_find(:first, :conditions => {:kind_id => Klass::KINDS['CONTEXT']})
  end

  def get_class
    self.name.constantize
  end

  def human_name
    self.get_class.respond_to?(:human_name) ? self.get_class.human_name : self.name
  end

  def self.rebuild!
    files = Dir["#{Rails.root}/app/models/**/*.rb"]
    files.each {|f|Object.require_or_load f}
    klasses = []
    (ActiveRecord::Base.class_eval "subclasses").select{|model| model.parent == Object }.each do |model|
      klasses << Klass.find_or_create_by_name_and_kind_id(model.name, KINDS['RECORD'])
    end
#    (Klass.all - klasses).each {|klass| klass.destroy}
  end
end
