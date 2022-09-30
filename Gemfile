# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.5'
gem 'bootsnap', require: false
gem 'lograge'
gem 'mysql2'
gem 'paranoia'
gem 'puma', '~> 5.0'
gem 'rails', '~> 7.0.4'
gem 'rubocop'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'rspec-rails'
end
