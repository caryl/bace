class Klass < ActiveRecord::Base
  has_many :klasses_permissions, :dependent => :destroy
  has_many :permissions, :through => :klasses_permissions
  
  has_many :metas
  has_many :permissions_metas, :foreign_key => "target_id"

  def get_class
    name.constantize
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
