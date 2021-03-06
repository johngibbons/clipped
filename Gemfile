source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.4'
# Use postgresql as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-turbolinks'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'dropzonejs-rails'

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'
gem 'omniauth-facebook'
gem "omniauth-google-oauth2"

# Use Puma as the app server
gem 'puma'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'figaro'
gem 'delayed_job_active_record'
gem "paperclip", "4.2.1"
gem 'aws-sdk', '< 2'
gem 's3_direct_upload' # direct upload form helper and assets
gem 'normalize-rails'
gem 'bourbon'
gem 'neat'
gem 'refills'
gem "font-awesome-rails"
gem 'will_paginate'
gem "animate-rails"
gem 'virtus'
gem "pundit"
gem 'acts-as-taggable-on', '~> 3.4'
gem 'sunspot_rails'
gem 'sunspot_solr'
gem 'sunspot-rails-tester'
gem "rack-timeout"
gem "autoprefixer-rails"
gem 'jcrop-rails-v2'
gem 'descriptive-statistics'
gem 'stripe', :git => 'https://github.com/stripe/stripe-ruby'
gem "closure_tree"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  gem 'rspec-rails', '~> 3.0'
  gem 'database_cleaner', '~> 1.4.0'
  gem 'faker'

end

group :test do
  gem 'minitest-reporters', '1.0.5'
  gem 'mini_backtrace',     '0.1.3'
  gem 'guard-minitest',     '2.3.1'
  gem 'shoulda-matchers',   '~> 3.0'
  gem 'capybara'
  gem "capybara-webkit"
  gem "factory_girl_rails", "~> 4.0"
  gem 'launchy', '~> 2.4.3'
  gem 'vcr', '~> 2.9.3'
  gem 'webmock'
end

group :development do
  gem 'guard-rspec', require: false  
end

group :production do
  gem 'newrelic_rpm'
  gem 'rails_12factor'
end


ruby "2.2.3"

