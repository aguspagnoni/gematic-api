source 'https://rubygems.org'

ruby '2.4.0'
gem 'rails', '~> 5.0.0'

# Database
gem 'pg'
gem 'pghero'
gem 'pg_query', '>= 0.9.0'

gem 'puma', '~> 3.0'
gem 'redis', '~> 3.0'

# Token based authentication
gem 'knock'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# HTML Template
gem 'slim'

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

# Image upload needs
gem 'carrierwave', '~> 1.0'
gem 'fog-aws'
gem 'mini_magick'

# Error handling
gem 'rollbar'

# Background processing
gem 'sidekiq'

# Pagination
gem 'kaminari'

# Thor scripting
gem 'thor'

# Admin
gem 'forest_liana'

# MISC
gem 'app_configuration'
gem 'paper_trail'

# Barcode Generation
gem 'barby'
gem 'chunky_png'

# Misc
gem 'normalizr'

group :development, :test do
  gem 'database_cleaner'
  gem 'byebug', platform: :mri
  gem 'rspec-rails', '>= 3.5.0'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'simplecov', require: false
end

group :development do
  gem 'erd'
  gem 'rubocop'
  gem 'listen', '~> 3.0.5'
  gem "localtower" # UI for model management
end

group :test do
  gem 'shoulda-matchers', '~> 3.1'
  gem 'timecop'
  gem 'rails-controller-testing'
end
