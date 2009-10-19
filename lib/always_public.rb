module AlwaysPublic
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    # public_actions :all
    # public_actions :index, :show, :edit
    def public_actions(*actions)
      cattr_accessor :always_public_actions
      self.always_public_actions = actions
    end
  end
end
