require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module Foo
  class Application < Rails::Application
    config.eager_load = false
    config.secret_key_base = 'sdfdsfsdfsd'
    config.consider_all_requests_local = false
  end
end
