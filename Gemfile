source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.1', '>= 6.1.3.1'

# Use mysql as the database for Active Record
gem 'mysql2', '~> 0.5.3'
# Use Puma as the app server
gem 'puma', '~> 5.2'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 6'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '~> 4.2'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 5.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.11'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# environment
gem 'dotenv-rails'

# Queue
gem 'sidekiq'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# for security
gem 'rack-attack'

# import
gem 'activerecord-import'

# for Google
gem "google-cloud-vision", "~> 0.38.0"
gem "google-cloud-translate", "~> 2.3.0"
gem "recaptcha", "~> 5.5.0"

# user account
gem 'devise'
gem 'devise-i18n'

# admin
gem "administrate"

# profiler
gem 'rack-mini-profiler'
gem 'flamegraph'
gem 'memory_profiler'
gem 'stackprof' # ruby 2.1+ only

# 応急処置
gem 'bundler-leak'
gem 'puma_worker_killer'

#
gem 'whenever'

#
gem 'paperclip'
gem 'mini_magick'

gem 'ransack'
gem "kaminari", ">= 1.2.1"
gem 'render_async'

gem 'twitter-text'

gem 'loadcss-rails'
gem 'bootstrap', '~> 4.4.1'

gem 'font-awesome-sass', '~> 5.12.0'

gem "chartkick", ">= 3.4.0"
gem 'gimei'
