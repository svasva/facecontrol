source 'http://rubygems.org'

gem 'rails', '3.1.0'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

group :test, :development do
	gem 'sqlite3'
  gem 'rspec-rails'
  gem 'capybara'
  gem 'factory_girl_rails'

  gem 'web-app-theme', :git => 'git://github.com/jweslley/web-app-theme.git'
  gem 'hpricot'
  gem 'ruby_parser'
  gem 'mocha'
  gem 'database_cleaner'
end

gem 'mysql2'

#our custom gems

# amf
gem "RocketAMF", :git => "git://github.com/rubyamf/rocketamf.git"
gem 'rubyamf', :git => 'git://github.com/rubyamf/rubyamf.git'
# state machine
gem 'aasm'
# background processor
gem 'resque'
gem 'resque-scheduler', :git => 'git://github.com/bvandenbos/resque-scheduler.git'
gem 'devise', :git => "git://github.com/plataformatec/devise.git" 
gem 'foreman'

# js compiler
gem 'therubyracer'

###

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "  ~> 3.1.0"
  gem 'coffee-rails', "~> 3.1.0"
  gem 'uglifier'
end

gem 'jquery-rails'

gem 'haml'
gem 'haml-rails'
gem 'will_paginate'


# Use unicorn as the web server
gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
end
