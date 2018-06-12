source 'https://rubygems.org'
gem 'json','~> 1.6'
gem 'sinatra'
gem 'sinatra-reloader'
gem 'datamapper'
gem 'bcrypt'

group :production do
    gem 'pg'
    gem 'dm-postgres-adapter'
end

group :development, :test do
    gem 'dm-sqlite-adapter'
end