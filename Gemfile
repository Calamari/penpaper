source 'https://rubygems.org'

gem 'rails', '3.2.13'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'sqlite3'

gem 'kramdown'

gem 'bcrypt-ruby' # bcrypt for has_secore_password
gem 'friendly_id' # provide friednly urls

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
  gem 'compass'
  gem 'compass-rails'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

group :test do
  gem 'fabrication'
  gem 'capybara'
end

group :development, :test do
  gem 'rspec-rails' # needs to be in development for the dev env to pick up the rspec rake tasks
  gem 'jasmine'

  # debugging
  gem 'debugger'
  gem 'binding_of_caller'
  gem 'better_errors'

  # make rails boot faster
  gem 'zeus'
end


# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
