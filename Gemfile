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
  # ba_spree.gemspec の実行時依存を BA_SPREE_PATH 内の gemspec で再帰的に辿り、見つかった engine を全て path 参照する
  # (spree_gmo_pg 経由の active_merchant_gmo_pg も含む)。一覧を gemspec だけに持ち、ここでは二重管理しない。
  # ここで path 参照しなかった engine は RubyGems の公開版が使われ、手元の変更が反映されない。
  # @see https://github.com/be-agile/giga-repeat/issues/1403
  engine_names = []
  queue = ["ba_spree"]
  until queue.empty?
    name = queue.shift
    gemspec = File.join(ba_spree_path, name, "#{name}.gemspec")
    next if engine_names.include?(name) || !File.exist?(gemspec)

    engine_names << name
    # gemspec 内の Dir[] はカレントディレクトリを見るため、engine ディレクトリで読む
    spec = Dir.chdir(File.dirname(gemspec)) { Gem::Specification.load(gemspec) }
    queue.concat(spec.runtime_dependencies.map(&:name))
  end
  engine_names.each { |name| gem name, path: File.join(ba_spree_path, name) }
else
  gem "ba_spree"
end
