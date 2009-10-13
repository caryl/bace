#config.load_paths += %W(#{Rails.root}/lib)
#config.action_controller.perform_caching  = true

#cache  observer
config.active_record.observers = :cache_observer

config.gem 'mislav-will_paginate', :version => '~> 2.3.10', :lib => 'will_paginate',
  :source => 'http://gems.github.com'

config.gem "thoughtbot-shoulda", :lib => "shoulda", :source => "http://gems.github.com"
config.gem "thoughtbot-factory_girl", :lib => "factory_girl", :source => "http://gems.github.com"


ActiveRecord::Base.send :include , BaceScope

ActionController::Base.send :include, BaceController
#ApplicationController.send :include, AuthenticatedSystem
#ApplicationController.send :include, DynamicSearch

#ActionController::Base.helper MenusHelper