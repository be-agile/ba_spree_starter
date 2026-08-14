source "https://rubygems.org"

ruby '3.3.7'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 8.1.0'

# Use mysql2 as the database for Active Record
gem "mysql2", "~> 0.5"

# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem "propshaft"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Use Redis adapter to run Action Cable in production
gem "redis", ">= 4.0.1"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "image_processing", "~> 1.13"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ]

  gem 'brakeman'
  gem 'dotenv-rails', '~> 3.1'
  gem 'rubocop', '~> 1.23'
  gem 'rubocop-performance'
  gem 'rubocop-rails'


end

group :development do
  gem "foreman"

  gem 'listen', '>= 3.0'

  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Preview emails in the browser [https://github.com/plataformatec/letter_opener]
  gem "letter_opener"

  # LSP support for Ruby
  gem 'ruby-lsp'
  gem 'ruby-lsp-rails'

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

group :test do
  gem 'spree_dev_tools'
  gem 'rails-controller-testing'
end

# Use Sidekiq for background jobs
gem 'sidekiq'
gem 'connection_pool', '~> 2.3' # lock to 2.3 to avoid breaking changes

# Use Devise for authentication
gem "devise"

# Sentry for error/performance monitoring
gem 'sentry-ruby'
gem 'sentry-rails'
gem 'sentry-sidekiq'

# Spree gems
# ba_spree が 5.3.6 のソースを @gem-override でコピーしているため、上限なしの
# '>= 5.3.0.rc2' ではなくバージョンを固定する
spree_opts = '= 5.3.6'
gem "spree", spree_opts
gem "spree_emails", spree_opts
gem "spree_sample", spree_opts
gem "spree_admin", spree_opts
gem "spree_storefront", spree_opts
# spree_i18n は本体と別バージョニングで 5.3.6 が存在しないため範囲指定にする
gem "spree_i18n", "~> 5.3"

# 上流 spree-starter にあった spree_stripe / spree_klaviyo / spree_paypal_checkout は外した。
# ba_spree が日本の決済手段 (銀行振込・代金引換・GMO PG・NP後払い) を用意しており、
# これらはいずれも API キーが無いと使えないため、初期状態では不要。
# 使いたい場合は Gemfile に戻して `rails g spree_stripe:install` 等を実行する。
# @see https://github.com/be-agile/giga-repeat/issues/1317

# ba_spree と、それが束ねる engine 群。
# BA_SPREE_PATH を指定すると giga-repeat の engines/ をローカル参照し、
# 未指定なら RubyGems から取得する (上流が SPREE_PATH でやっているのと同じ形)。
ba_spree_path = ENV.fetch("BA_SPREE_PATH", nil)

if ba_spree_path
  # giga-repeat #1317 タスク2 でリネーム済みのため、gem 名とディレクトリ名は一致している。
  # active_merchant_gmo_pg は spree_gmo_pg の依存だが RubyGems に未公開のため、
  # ここで明示的に path 参照する。spree_order_total_discount も同様に未公開で、
  # ba_spree.gemspec が依存に持つ (Spree::BaseHelper#sort_adjustments_with_flat_percent_last が
  # Spree::Calculator::FlatPercentOrderTotal を参照する) ため、ここに列挙しないと
  # bundle install が依存を解決できない。
  # 一覧は ba_spree.gemspec の add_dependency と一致させること。
  %w[
    ba_spree
    spree_address_format_i18n
    spree_zip_autocomplete
    ba_spree_bank_transfer
    ba_spree_cash_on_delivery
    spree_np_atobarai
    active_merchant_gmo_pg
    spree_gmo_pg
    spree_direct_debit
    spree_custom_email
    ba_spree_loyalty_points
    spree_materials
    spree_order_total_discount
    ba_spree_related_products
    spree_products_payment_methods
    spree_limit_order_quantity
    spree_option_type_description
    spree_search_with_description
    spree_auto_capture_digital
    spree_digital_payment_notice
    spree_checkout_signup_promotion
    ba_spree_google_analytics
    spree_yahoo_ads
  ].each { |name| gem name, path: File.join(ba_spree_path, name) }
else
  gem "ba_spree"
end
