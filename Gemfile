source 'https://rubygems.org'
ruby '2.1.2'

gem 'bootstrap-sass', '3.1.1.1'
gem 'coffee-rails'
gem 'rails', '4.1.1'
gem 'haml-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'pg', '0.17.0'
gem 'bcrypt'
gem "bootstrap_form", "~> 2.7"
gem 'sidekiq', "3.3.3"
gem 'unicorn'
gem "sentry-raven"
gem "carrierwave"
gem "carrierwave-aws"
gem "mini_magick"


group :development do
  gem 'thin'
  gem "better_errors"
  gem "binding_of_caller"
  gem "letter_opener"
end

group :development, :test do
  gem 'pry'
  gem 'pry-nav'
  gem 'rspec-rails', '~> 3'
end

group :test do
  gem 'database_cleaner', '1.4.1'
  gem 'shoulda-matchers', '2.7.0'
  gem 'vcr', '2.9.3'
  gem 'fabrication'
  gem 'faker'
  gem 'capybara'
  gem 'capybara-email'
end

group :production do
  gem 'rails_12factor'
end

