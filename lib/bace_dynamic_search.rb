module BaceDynamicSearch
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
      resource = Resource.current
      dynamic_searches = DynamicSearch.unlimit_find(:all, :conditions => {:target_klass_id => klass.id, :resource_id => resource.id})
      target_metas = klass.metas.unlimit_find(:all)
      value_metas = target_metas + Klass.context.metas.unlimit_find(:all)

      render :partial=>'/dynamic_searches/use', :locals=>{:dynamic_searches => dynamic_searches, :resource => resource, :klass => klass, :target_metas => target_metas, :value_metas => value_metas}
    end

    def prepare_dynamic_search
      return if params[:bace_search].blank?
      limit_scopes = BaceUtils.search_params_to_limits(params[:bace_search])
      params[:dynamic_search_model] = limit_scopes.first.target_klass.get_class
      params[:dynamic_search] = limit_scopes
    end
  end
end