#시나트라 사용할꺼임
#시나트라 쓰는데 계속 새로고침해줘(reload)
#'/'이 경로로 오면 index.html 파일을 보내줘
gem 'json','~> 1.6'
require 'sinatra'
require "sinatra/reloader"
require 'bcrypt'
require './model.rb'



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
    @posts =Post.all.reverse
    # @posts =Post.all(order=>[:id.desc])
    
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

get '/posts/:id' do
    @id=params[:id]
    @post=Post.get(@id)
    erb :'posts/show'    
end

get '/posts/destroy/:id' do
    @id=params[:id]
    Post.get(@id).destroy
    erb :'posts/destroy'
end


#값을 받아서 뿌려주기 위한 용도
get '/posts/edit/:id' do
    @id=params[:id]
    @post =Post.get(@id)
    erb :'posts/edit'
end

get '/posts/update/:id' do
     @id=params[:id]
    Post.get(@id).update(title: params[:title], body: params[:body])
    redirect '/posts/'+@id
end


#**************USER****************USER***************USER********************USER***********

get '/user' do
    
   erb :'/user/user'
end

get '/user/create' do
    #비번확인 다르면 가입x 같으면 가입시킴
    # if params[:pwd] != params[:pwd_confirm]
    #     redirect '/'
    # else
        
    # end
    @name=params[:name]
    @email=params[:email]
    @pwd = params[:pwd]
    User.create(name: @name,email: @email, pwd: @pwd)
   erb :"user/create"
end

#게시글 모두 보여주는 곳
get '/users' do
    @users =User.all
    # @users =user.all(order=>[:id.desc])
    
    erb :"user/users"
end

