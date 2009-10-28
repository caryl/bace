# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.4' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
config.reload_plugins = true if Rails.env == 'development'

config.active_record.observers = :bace_cache_observer

config.gem 'mislav-will_paginate', :version => '~> 2.3.10', :lib => 'will_paginate',
  :source => 'http://gems.github.com'

config.gem "thoughtbot-shoulda", :lib => "shoulda", :source => "http://gems.github.com"
config.gem "thoughtbot-factory_girl", :lib => "factory_girl", :source => "http://gems.github.com"
end