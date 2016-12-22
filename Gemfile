# frozen_string_literal: true
source 'http://rubygems.org'

gem 'bundler', '>= 1.8.4'
gem 'rails', '~> 4.2.7'
gem 'sprockets'
gem 'sass', '3.4.19'
gem 'sass-rails'
gem 'compass-rails'
gem 'mysql2', '~> 0.3.18'
gem 'responders'
gem 'coffee-rails'
gem 'angular-rails-templates', '>= 1.0'
gem 'httparty'
gem 'composite_primary_keys'
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw]
gem 'nokogiri'
gem 'bootstrap-sass'
gem 'whenever', require: false
gem 'activerecord-import'

source 'http://rails-assets.org' do
	 gem 'rails-assets-lodash'
	 gem 'rails-assets-angular'
	 gem 'rails-assets-angular-ui-router', '>= 0.3.0'
	 gem 'rails-assets-angular-material', '1.0.9'
	 gem 'rails-assets-daniel-nagy--md-data-table'
	 gem 'rails-assets-moment'
	 gem 'rails-assets-moment-timezone'
	 gem 'rails-assets-angular-moment', '1.0.0.beta.4'
	 gem 'rails-assets-angular-sanitize'
end

group :development do
	 gem 'meta_request'
	 gem 'rails-erd'
	 gem 'brakeman'
end

group :development, :test do
	 gem 'rubocop'
	 gem 'rails-assets-angular-mocks'
	 gem 'fabrication'
end

group :production do
	 gem 'uglifier', '>= 1.3.0'
	 # gem 'therubyracer'
end
