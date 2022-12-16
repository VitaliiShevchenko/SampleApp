require_relative "boot"

require "rails/all"




# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SampleApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    #Logger switch off all information in console
    #config.logger = Logger.new(STDOUT)
    #config.logger = Log4r::Logger.new("Application Log")
    #THIS Logger switch off all debug information in console
    #config.log_level = :warn # In any environment initializer, or
    # Rails.logger.level = 0 # at any time

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
