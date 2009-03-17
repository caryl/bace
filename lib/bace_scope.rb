module BaceScope
  module ClassMethods
    def find_with_bace(*args)
      scopes = Current.user.scopes_for_resource(Current.controller, Current.action) if Current.user_proc
      if scopes.present?
        with_scope(:find => {:conditions => LimitScope.full_scops_conditions(scopes)}) do
          find_without_bace( *args )
        end
      else
        find_without_bace(*args)
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