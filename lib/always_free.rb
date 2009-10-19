module AlwaysFree
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    # free_actions :all
    # free_actions :index, :show, :edit
    def free_actions(*actions)
      cattr_accessor :always_free_actions
      self.always_free_actions = actions
    end
    
    def free_model
      cattr_accessor :is_free_model
      self.is_free_model = true
    end
  end
end
