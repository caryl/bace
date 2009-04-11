class Klass < ActiveRecord::Base
  has_many :klasses_permissions, :dependent => :destroy
  has_many :permissions, :through => :klasses_permissions
  
  has_many :metas

  def get_class
    self.name.constantize
  end

  def human_name
    self.get_class.human_name
  end

  def self.rebuild!
    files = Dir["#{Rails.root}/app/models/**/*.rb"]
    files.each {|f|Object.require_or_load f}
    klasses = []
    (ActiveRecord::Base.class_eval "subclasses").select{|model| model.parent == Object }.each do |model|
      klasses << Klass.find_or_create_by_name(model.name)
    end
#    (Klass.all - klasses).each {|klass| klass.destroy}
  end
end
