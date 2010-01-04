module BaceHelper
  def meta_name(klass_name, meta_key)
    m = Meta.first(:joins => :klass, :conditions => {:klasses => {:name => klass_name.classify}, :key => meta_key})
    m.try(:name)
  end
end