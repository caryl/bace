#config.load_paths += %W(#{Rails.root}/lib)
#config.action_controller.perform_caching  = true
#TODO:reload plugins
config.reload_plugins = true if Rails.env == 'development'

#TODO:cache  observer
#config.active_record.observers = :bace_cache_observer
config.active_record.observers = :bace_cache_observer

config.gem 'will_paginate', :version => '~> 2.3.11', :source => 'http://gemcutter.org'

config.gem "thoughtbot-shoulda", :lib => "shoulda", :source => "http://gems.github.com"
config.gem "factory_girl", :source => "http://gemcutter.org"

ActionController::Base.send :include, BaceController

ActiveRecord::Base.send :include , BaceModel
