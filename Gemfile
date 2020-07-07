source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2'
# Use sqlite3 as the database for Active Record
gem 'pg'
# Use Puma as the app server
gem 'puma', '~> 3.7'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'therubyracer'
gem 'devise_token_auth'
gem 'devise'
gem 'omniauth'
gem 'rack-cors', :require => 'rack/cors'

#gem "aws-sdk-s3", require: false
#pdf report
gem 'prawn'
gem 'prawn-table'
#gem "bootstrap-sass-rails"
gem 'mailboxer'
gem 'workflow'
gem 'paper_trail'
gem 'carrierwave', '~> 1.0'
gem 'carrierwave-imageoptimizer'
gem "fog"
gem 'rmagick'
gem "mini_magick"
gem 'jquery-rails'
gem 'will_paginate', '>= 3.1'
# gem 'bootstrap-will_paginate' #mailboxer
gem 'gravatar_image_tag'  #mailboxer
gem 'bootstrap-sass', '~> 3.3.7'
gem 'momentjs-rails', '>= 2.9.0'
gem 'bootstrap3-datetimepicker-rails', '~> 4.17.47'
#Elastic Search dependency
 gem 'elasticsearch-model', git: 'git://github.com/elastic/elasticsearch-rails.git', branch: 'master'
gem 'elasticsearch-rails', git: 'git://github.com/elastic/elasticsearch-rails.git', branch: 'master'
gem 'faker', :git => 'https://github.com/stympy/faker.git', :branch => 'master'
gem 'dotenv-rails', require: 'dotenv/rails-now'
#for handling ES ()
gem 'sprockets-es6'
#Internationalization
gem 'i18n', require: true
# payments
gem 'square_connect'
#gem 'stripe'

#Action Cable
gem 'redis'
#schedule CronJob
gem 'whenever', require: false
#CMS
#gem 'refinerycms-dragonfly', '~> 1.0'
# gem 'refinerycms', '~> 4.0.2'
#gem 'refinerycms-authentication-devise', '~> 2.0.0'
#gem 'foreman', '~>0.84'


group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
