source 'https://rubygems.org'

ruby "2.3.1"

gem "rails", "5.0.0"

gem "dotenv-rails"
gem "coffee-rails"
gem "font-awesome-sass"
gem 'haml-rails'
gem "jbuilder"
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'pg'
gem "sass-rails"
gem "uglifier"
gem 'zeroclipboard-rails'

group :development do
  gem 'annotate'
  gem 'bullet'
  gem 'quiet_assets'
  gem 'spring'
end

group :development, :test do
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'cucumber-rails', require: false
  gem 'cucumber'
  gem 'database_cleaner' #rewinderはcucumberに対応していないかも
  gem 'database_rewinder'
  gem 'factory_girl_rails'
  gem 'launchy'
  gem 'pry-rails'
  gem 'pry-doc'
  gem 'pry-stack_explorer'
  gem 'rspec-rails', '~> 3.5' # 2016/11/27 現在では 3.5.x を使うよう公式情報にあった
  gem 'tachikoma'
  gem 'timecop'
end

group :production do
  gem 'rails_12factor'
end
