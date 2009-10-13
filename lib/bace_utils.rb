class BaceUtils
  def self.append_dynamic_search(klass, find_scope, params)
    if params[:dynamic_search_model] == klass
      dynamic_condition = params[:dynamic_search].to_condition
      if dynamic_condition.present?
        dynamic_condition = ' and ' + dynamic_condition if find_scope[:conditions].present?
        find_scope[:conditions] ||= ''
        find_scope[:conditions] += dynamic_condition
      end
    end
    find_scope
  end
end