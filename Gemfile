source 'https://rubygems.org'

ruby "2.3.0"
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.7.1'
# Use sqlite3 as the database for Active Record
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'
gem 'sidekiq'
gem "sidekiq-cron", "~> 0.4.0"
gem 'autoscaler'
gem 'sidekiq-batch'
gem 'sidekiq-superworker'
gem 'sidekiq-bulk'

#gem 'rails_autoscale_agent'

gem 'bugsnag'
# Use Unicorn as the app server
gem 'puma'
gem 'smarter_csv'
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
#gem 'scout_apm'

gem 'clockwork'

#gem 'tunemygc'

gem 'mongoid'
gem 'bson_ext'
gem 'mongoid-encrypted-fields'
gem "gibberish"
gem 'desk_api'

gem 'version'
gem 'redis'
#gem 'fastercsv'

#gem 'rchardet'
gem 'charlock_holmes'

gem 'bootstrap', '~> 4.0.0.alpha3'


gem 'rails_12factor'

gem 'aws-sdk', '~> 2'
gem 'carrierwave-mongoid', :require => 'carrierwave/mongoid'


group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'dotenv-rails'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
  gem 'pp_sql'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end
