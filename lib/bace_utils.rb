class BaceUtils
  def self.search_params_to_limits(params)
    limit_scopes = []
    DynamicSearch.find(params[:id]).each_with_index do |search, i|
      limit_scope = search.becomes(LimitScope).clone
      limit_scope.key_meta_id ||= limit_scope.target_meta_id
      limit_scope.value = params[:value][i]
      limit_scope.value_meta_id = params[:meta][i]
      limit_scopes << limit_scope
    end
    limit_scopes
  end

  def self.append_dynamic_search(klass, find_scope, params)
    if params[:dynamic_search_model] == klass
      limit_scopes = params[:dynamic_search]
      if limit_scopes.present?
        find_scope[:conditions] ||= ''
        find_scope[:conditions] += limit_scopes.map(&:to_condition).join(' AND ')
        metas = limit_scopes.map{|l| Meta.unlimit_find(l.target_meta_id)}
        find_scope[:include] |= metas.flatten.map(&:include).uniq.compact
        find_scope[:joins] |= metas.flatten.map(&:joins).uniq.compact
      end
    end
    find_scope
  end
end