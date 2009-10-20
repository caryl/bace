module BaceModelExclude
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def free_model
      cattr_accessor :is_free_model
      self.is_free_model = true
    end

    def always_free?
      self.respond_to?(:is_free_model) && self.is_free_model
    end
  end
end
