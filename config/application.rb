require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

Dotenv.load(File.expand_path("../../.env.#{Rails.env}", FILE))
# Dotenv::Railtie.load

SECRET_KEY_BASE = ENV['secret_key_base']

module RecipeMe
  class Application < Rails::Application
    # Load defaults from config/*.env in config
    # Dotenv.load *Dir.glob(Rails.root.join("config/**/*.env"), File::FNM_DOTMATCH)
    #
    # # Override any existing variables if an environment-specific file exists
    # Dotenv.overload *Dir.glob(Rails.root.join("config/**/*.env.#{Rails.env}"), File::FNM_DOTMATCH)


    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.load_path += Dir["#{Rails.root.to_s}/config/locales/**/*.{rb,yml}"]
    config.autoload_paths += Dir[Rails.root.join('app', 'models', '{**}')]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    # config.secret_key_base = "382f2d8466117e883fb9fbe455e553d3ab85647555d5dd58514cdaee8e0b7c9608079c40bb22cd02c14437c8f65a5ba89c52730299d7fc05b34971cbe95d00ab"
  end
end
