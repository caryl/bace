module BaceScope
  module ClassMethods
    def find_with_bace(*args)
      with_scope(:find => {:conditions => ['name = ?', Current.action]}) do
        find_without_bace( *args )
      end
    end
  end

  def self.included(base)
    base.class_eval do
      extend ClassMethods
      class << self
        alias_method_chain :find, :bace
      end
    end
  end
end