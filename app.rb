#시나트라 사용할꺼임
#시나트라 쓰는데 계속 새로고침해줘(reload)
#'/'이 경로로 오면 index.html 파일을 보내줘
gem 'json','~> 1.6'
require 'sinatra'
require "sinatra/reloader"
require 'rest-client'
require 'json'
require 'httparty'
require 'nokogiri'
require 'uri'
require 'date'
require 'csv'
require 'data_mapper' # metagem, requires common plugins too.
# datamapper 로그찍기
DataMapper::Logger.new($stdout, :debug)
# need install dm-sqlite-adapter
DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/blog.db")


class Post
  include DataMapper::Resource
  property :id, Serial
  property :title, String
  property :body, Text
  property :created_at, DateTime
end

# Perform basic sanity checks and initialize all relationships
# Call this when you've defined all your models
DataMapper.finalize

# automatically create the post table
Post.auto_upgrade!


#시나트라 사용할꺼임
#시나트라 쓰는데 계속 새로고침해줘(reload)
#'/'이 경로로 오면 index.html 파일을 보내줘

get '/' do
    send_file 'views/index.html'
end
#'/lunch' 경로로 오면 @lunch.sample을 erb에서 보여줘
get '/lunch' do 
    @lunch =["짜장면","짬뽕","탕슈육","건빵","다마네기"]
    erb :lunch
end


#게시글 모두 보여주는 곳
get '/posts' do
    @posts =Post.all
    erb :"posts/posts"
end

#게시글을 쓸수 있는곳
get '/posts/new' do
    erb :"posts/new"    
end

get '/posts/create' do
    @title=params[:title]
    @body = params[:body]
    Post.create(title: @title, body: @body)
   erb :"posts/create"
end