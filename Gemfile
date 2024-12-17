source "https://rubygems.org"

gem "rails", "~> 8.0.1"
gem "propshaft"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "cssbundling-rails"
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"
gem "jwt"
gem "redis"
gem "tailwindcss-rails"
gem "sidekiq"
gem "image_processing", require: false
gem "clockwork", require: false
gem "administrate"
gem "administrate-field-active_storage", "~> 1.0"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

gem "solid_cache"
gem "solid_queue"
gem "solid_cable"
gem "bootsnap", require: false
gem "kamal", require: false
gem "thruster", require: false

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "rspec-rails", require: false
  gem "factory_bot_rails"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
  gem "standard", require: false
  gem "rubocop-rspec", require: false
  gem "rubocop", require: false
  gem "dotenv"
end

group :development do
  gem "reek", require: false
  gem "web-console"
  gem "guard", require: false
  gem "guard-reek", require: false
  gem "guard-rspec", require: false
end

group :test do
  gem "capybara", require: false
  gem "selenium-webdriver", require: false
  gem "webmock", require: false
  gem "bullet"
  gem "rails-controller-testing"
  gem "simplecov", require: false
end
