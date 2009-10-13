module DynamicSearch
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
    base.send(:helper_method, :dynamic_search_for)
  end

  module ClassMethods
    def dynamic_searchable(*action)
      self.send(:prepend_before_filter, :prepare_dynamic_search, {:only => action})
      self.send(:private, :prepare_dynamic_search)
      self.send(:private, :dynamic_search_for)
    end
  end

  module InstanceMethods
    def dynamic_search_for(model)
      klass = Klass.unlimit_find(:first, :conditions => {:name => model.name})
      target_metas = klass.metas.unlimit_find(:all)
      value_metas = target_metas + Klass.context.metas.unlimit_find(:all)
      render :partial=>'/dynamic_search/form', :locals=>{:model => model, :klass => klass, :target_metas => target_metas, :value_metas => value_metas}
    end

    def prepare_dynamic_search
      return if params[:limit_scope].blank?
      limit_scope = LimitScope.new(params[:limit_scope])
      limit_scope.key_meta_id ||= limit_scope.target_meta_id
      params[:dynamic_search_model] = limit_scope.target_klass.get_class
      params[:dynamic_search] = limit_scope
    end
  end

end