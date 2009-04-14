class CacheObserver <  ActiveRecord::Observer
  observe User, RolesUser, Role, PermissionsRole, Permission, Resource, Klass, KlassesPermission, LimitScope, Meta

  #reset_cache
  def after_save(record)
    Rails.cache.clear
    Rails.logger.debug("THE CACHE EXPIRED AFTER SAVE AT:#{Time.now}")
  end

  def after_destroy(record)
    Rails.cache.clear
    Rails.logger.debug("THE CACHE EXPIRED AFTER DESTROY AT:#{Time.now}")
  end
end