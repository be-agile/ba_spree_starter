require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SpreeStarter
  class Application < Rails::Application
    config.to_prepare do
      # Load application's model / class decorators
      Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.eager_load_paths << Rails.root.join("extras")

    # 日本仕様の設定。
    # available_locales を明示しないと、engine 側の
    # `config.i18n.available_locales += [:ja]` が nil に対する加算になり起動できない
    config.i18n.load_path += Dir[Rails.root.join("config", "locales", "**", "*.{rb,yml}").to_s]
    config.i18n.available_locales = [:ja]
    config.i18n.default_locale = :ja
    config.i18n.locale = :ja
    config.time_zone = "Tokyo"

    # https://github.com/rails/rails/issues/45826
    # ActiveSupport::SafeBuffer は Spree の seed が Store の preference に
    # html_safe な文字列を格納するために必要
    config.active_record.yaml_column_permitted_classes = [Symbol, BigDecimal, Date, Time, ActiveSupport::TimeWithZone, ActiveSupport::TimeZone, ActiveSupport::HashWithIndifferentAccess, ActiveSupport::SafeBuffer]
  end
end
