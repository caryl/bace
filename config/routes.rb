ActionController::Routing::Routes.draw do |map|
  map.resources :menus

  map.resources :klasses, :shallow => true do |klass|
    klass.resources :limit_groups do |limit_group|
      limit_group.resources :limit_scopes
    end
    klass.resources :metas
  end

  map.resources :roles, :member => {:edit_permissions => :get, :edit_limits => :get}
  map.resources :permissions, :member => {:edit_klasses => :get}
  map.resources :resources
  map.resources :users

  map.root :controller => 'session', :action => 'login'
  map.login '/login', :controller => 'session', :action => 'login'
  map.logout '/logout', :controller => 'session', :action => 'logout'
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
