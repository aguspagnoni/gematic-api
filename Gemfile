source 'https://rubygems.org'

ruby '2.4.0'
gem 'rails', '~> 5.0.0'
gem 'pg'
gem 'puma', '~> 3.0'
gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

# Image upload needs
gem 'carrierwave', '~> 1.0'
gem 'fog-aws'
gem 'mini_magick'

# Error handling
gem 'rollbar'

group :development, :test do
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
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem "localtower" # UI for model management
end

group :test do
  gem 'shoulda-matchers', '~> 3.1'
  gem 'timecop'
  gem 'rails-controller-testing'
end
