# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.2.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|

  config.time_zone = 'UTC'

  # The internationalization framework can be changed to have another default locale (standard is :en) or more load paths.
  # All files from config/locales/*.rb,yml are added automatically.
  # config.i18n.load_path << Dir[File.join(RAILS_ROOT, 'my', 'locales', '*.{rb,yml}')]
  config.i18n.default_locale = 'zh-CN'

  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random, 
  # no regular words or you'll be exposed to dictionary attacks.
  config.action_controller.session = {
    :session_key => '_bace_session',
    :secret      => '4deed51e76bc350ccf5703e473cc5488dfd44103ac3b62292fb33aee50d36f0da1942419a45f0dd6d1958e5241586d2b541b29efd877ec258e4d8580adfa75e3'
  }

  config.load_paths += %W(#{RAILS_ROOT}/lib)
  
  #mem_cache and observer
  config.cache_store = :mem_cache_store
  config.active_record.observers = :cache_observer
  
  config.gem 'mislav-will_paginate', :version => '~> 2.2.3', :lib => 'will_paginate',
    :source => 'http://gems.github.com'

  config.gem "thoughtbot-shoulda", :lib => "shoulda", :source => "http://gems.github.com"
  config.gem "thoughtbot-factory_girl", :lib => "factory_girl", :source => "http://gems.github.com"

  config.gem 'gettext'
end
