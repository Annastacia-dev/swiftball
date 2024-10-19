require_relative "boot"

require "rails/all"
require 'web-push'
require 'obscenity/active_model'
require 'will_paginate/array'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Swiftball
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w(assets tasks))

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # timezone config
    config.time_zone = 'UTC' # Set default time zone to UTC
    config.active_record.default_timezone = :utc # Store database time in UTC

    # config.eager_load_paths << Rails.root.join("extras")
    config.autoload_paths << "#{Rails.root}/db/data"

    # mailing
    config.action_mailer.delivery_method = :smtp
     username =  Rails.application.credentials.mail[:username]
     password =  Rails.application.credentials.mail[:password]

    config.action_mailer.smtp_settings = {
      user_name:  username,
      password:  password,
      domain: Rails.application.credentials.mail[:domain],
      address: Rails.application.credentials.mail[:address],
      port: Rails.application.credentials.mail[:port],
      authentication: Rails.application.credentials.mail[:authentication],
      enable_starttls_auto: true
    }

    # Sidekiq
    Sidekiq.configure_client do |config|
      config.redis = {
        url: ENV['REDISCLOUD_URL'],
        network_timeout: 5
      }
    end

    Sidekiq.configure_server do |config|
      config.redis = {
        url: ENV['REDISCLOUD_URL'],
        network_timeout: 5
      }
    end
  end
end
