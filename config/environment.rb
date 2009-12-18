# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|

config.active_record.observers = :bace_cache_observer

config.gem 'will_paginate', :version => '~> 2.3.11', :source => 'http://gemcutter.org'

config.gem "thoughtbot-shoulda", :lib => "shoulda", :source => "http://gems.github.com"
config.gem "thoughtbot-factory_girl", :lib => "factory_girl", :source => "http://gems.github.com"
end
