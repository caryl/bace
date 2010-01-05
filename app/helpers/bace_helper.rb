module BaceHelper
  def meta_name(klass_name, meta_key)
    Meta.cached_meta_name(klass_name, meta_key).try(:name)
  end

  def resource_name(controller_name = controller_name, action_name = action_name)
    Resource.cached_resource_name(controller_name, action_name).try(:name)
  end
end