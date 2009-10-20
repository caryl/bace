module BaceControllerExclude
  def self.included(base)
    base.extend(ClassMethods)
    base.send(:include, InstanceMethods)
  end

  module ClassMethods
    # free_actions :all
    # free_actions :index, :show, :edit
    def free_actions(*actions)
      cattr_accessor :always_free_actions
      self.always_free_actions = actions
    end
    
    # public_actions :all
    # public_actions :index, :show, :edit
    def public_actions(*actions)
      cattr_accessor :always_public_actions
      self.always_public_actions = actions
    end

    def always_public?(action)
      self.respond_to?(:always_public_actions) && (self.always_public_actions & [action.to_sym, :all]).present?
    end

    def always_free?(action)
      self.respond_to?(:always_free_actions) && (self.always_free_actions & [action.to_sym, :all]).present?
    end
  end

  module InstanceMethods
    def always_public?
      self.class.always_public?(action_name)
    end

    def always_free?
      self.class.always_free?(action_name)
    end
  end
end
