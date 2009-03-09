ActionController::Routing::Routes.draw do |map|
  map.resources :metas
  map.resources :limit_scopes
  map.resources :roles, :member => {:edit_permissions => :get}
  map.resources :permissions, :member => {:edit_metas => :get}
  map.resources :resources
  map.resources :users

  map.root :controller => 'session', :action => 'login'
  map.login '/login', :controller => 'session', :action => 'login'
  map.logout '/logout', :controller => 'session', :action => 'logout'
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
