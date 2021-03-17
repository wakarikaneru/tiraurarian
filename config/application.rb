require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Tiraurarian
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.time_zone = 'Tokyo'
    config.i18n.default_locale = :ja

    # security
    config.middleware.use Rack::Attack

    # profiler
    Rack::MiniProfiler.config.storage = Rack::MiniProfiler::MemoryStore
    # set RedisStore
    if Rails.env.production?
      Rack::MiniProfiler.config.storage_options = { url: ENV["REDIS_SERVER_URL"] }
      Rack::MiniProfiler.config.storage = Rack::MiniProfiler::RedisStore
    end

    config.action_view.field_error_proc = Proc.new do |html_tag, instance|
      html_tag
    end
  end
end
