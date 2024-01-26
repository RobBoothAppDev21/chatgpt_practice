source "https://rubygems.org"

ruby "3.3.0"


gem "bootsnap", require: false # Reduces boot times through caching; required in config/boot.rb
gem "importmap-rails" # Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "jbuilder" # Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "omniauth"
gem "pg", "~> 1.1" # Use postgresql as the database for Active Record
gem "puma", ">= 5.0" # Use the Puma web server [https://github.com/puma/puma]
gem "sprockets-rails" # The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "stimulus-rails" # Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "rails", "~> 7.1.3" # Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "redis", ">= 4.0.1" # Use Redis adapter to run Action Cable in production
gem "tailwindcss-rails" # Use Tailwind CSS [https://github.com/rails/tailwindcss-rails]
gem "tzinfo-data", platforms: %i[ windows jruby ] # Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "turbo-rails" # Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]

# gem "bcrypt", "~> 3.1.7" # Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "image_processing", "~> 1.2" # Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "kredis" # Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]

group :development, :test do
  gem "debug", platforms: %i[ mri windows ] # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "factory_bot_rails"
  gem "faker"
  gem "rspec-rails", '~> 6.1.0' # Behavior driven development testing [https://github.com/rspec/rspec-rails]
end

group :development do
  gem "annotate" # Summarize current schema [https://github.com/ctran/annotate_models]
  gem "better_errors"
  gem "bullet" # Identify and optimize unneccessary database quieries [https://github.com/flyerhzm/bullet]
  gem "letter_opener"
  gem "rubocop", require: false # Enforcing consistent coding styles - linter [https://github.com/rubocop/rubocop]
  gem "rubocop-performance" # Performance Monitoring
  gem "rubocop-rails" # Rails Style Monitoring
  gem "rubocop-rspec" # Rspec Style Monitoring
  gem "web-console" # Use console on exceptions pages [https://github.com/rails/web-console]

  # gem "rack-mini-profiler" # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "spring" # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end
