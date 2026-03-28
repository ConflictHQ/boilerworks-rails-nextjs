require_relative "boot"

require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"

Bundler.require(*Rails.groups)

module Boilerworks
  class Application < Rails::Application
    config.load_defaults 8.0

    # API-only mode
    config.api_only = true

    config.autoload_lib(ignore: %w[assets tasks])

    # Session store for cookie-based auth
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore,
      key: "_boilerworks_session",
      same_site: :lax,
      secure: Rails.env.production?

    config.generators.system_tests = nil

    config.generators do |g|
      g.test_framework :rspec
      g.factory_bot suffix: "factory"
    end
  end
end
