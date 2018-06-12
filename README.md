### 시나트라 정리

##### 준비사항

##### 필수 gem 설치

`$ gem install sinatra`

`$ gem install sinatra-reloader`

 ##### 시작페이지 만들기(routing 설정및 view 설정)

~~~ruby
#app.rb
require 'sinatra'
require 'sinatra/reloader'

get '/' do  #routing,'/' 경로로 들어왔을때
    send_file 'index.html' #index.html 파일을 보내줘
end

get '/lunch' do # '/lunch' 경로로 들어왔을때
    erb :lunch #views폴더 안에 있는 luch.erb를 보여줘
end
~~~



##### 폴더구조

- app.rb
- views/
  - .erb
  - layout.erb
- index.erb

##### layout

~~~erb
<html>
    <head>
        
    </head>
    <body>
        <%=yield%>
    </body>
</html>
~~~



~~~ruby
def hello
    puts "hello"
    yield
    puts "bye"
end
#{} : block /코드덩어리
hello {puts "taewoo}
#=> hello taewoo bye
~~~



##### erb에서 루비코드 활용하기

~~~ruby
#app.rb
get '/lunch' do
    @lunch =["바스버거"]
    erb :lunch
end

~~~

~~~html
<!-- lunch.erb -->
<%= @lunch %> 
~~~

##### params

- variable routing

  ~~~ruby
  #app.rb
  get '//hello/:name'
  @name =params[:name]
  erb :name
  end
  ~~~

- `form` tag를 통해서 받는법

  ~~~html
  <form action="/posts/create">
      제목 : <input name="title">
  </form>
  ~~~

  ~~~ruby
  #app.rb
  #params
  #{title: "블라블라"}
  get '/posts/create' do
      @title = params[:title]
  end
  ~~~

  

### ORM : Object Relational Mapping

객체지향언어(ruby)와 데이터베이스(sqlite)를 연결하는 것을 도와주는 도구

[Datamapper](http://recipes.sinatrarb.com/p/models/data_mapper)

##### 사전준비사항

`$gem install datamapper`

`$gem install dm-sqlite-adapter`

~~~ruby
#app.re
#c9에서 json라이브러리 충돌로 인한 코드
 gem 'json','~> 1.6'

require 'data_mapper'
# blog.db 세팅

DataMapper::setup(:default, "sqlite3://

# Post 객체(object) 생성

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
~~~

##### 데이터 조작

- 기본

  `post.all`

  

- C(create)

  ~~~ruby
  #첫번째 방법
  Post.create(title : "test",body : "test")
  #두번째 방법
  p=Post.new
  p.title="test"
  p.body="test"
  p.save #실제로 db에 작성됨
  ~~~

  

- R(Read)

  ~~~ruby 
  Post.het(1) #get(id)
  ~~~

- U(update)

  ~~~ruby
  #첫번째 방법
  Post.get(1).update(title:"test", body:"test")
  #두번째 방법
  p=Post.get(1)
  p.title="제목"
  p.body="내용"
  p.save
  ~~~

- D(Destroy)

  ~~~ruby
  Post.get(1)destroy
  ~~~

  

##### CRUD만들기

- Create

  ~~~ruby
  #사용자에게 입력받는창
  get '/posts/new' do
  end
  #실제로 디비에 저장하는 곳
  get '/posts/create' do
      Post.create(title:params[:title],body:params[:body])
  end
  ~~~

  

##### Read:variable routing

~~~ruby
#app.rb
get 'posts/:id
@post=post.get(@id)
end

~~~

##### bundler를 통한 gem관리

> 어플리케이션의 의존성(dependency)를 관리 해주는 bundler

1.bundler 설치

`gem install bundler`

2.`Gemfile`작성: 루트 디렉토리에 만들기

~~~ruby
source "http://rubygems.org"
gem 'sinatra'
gem 'sinatra-reloader'
gem 'datamapper'
gem 'dm-sqlite-adapter'
~~~

#### heroku 배포

1. heroku에서 addon 추가

   `hreoku postgre`

2. `Gemfile` 수정

   ~~~ruby
   source 'https://rubygems.org'
   gem 'json','~> 1.6'
   gem 'sinatra'
   gem 'sinatra-reloader'
   gem 'datamapper'
   gem 'bcrypt'
   gem 'json'
   gem 'rack'
   
   group :production do
       gem 'pg'
       gem 'dm-postgre-adapter'
   end
   
   group :development, :test do
       get 'dm-sqlite-adapter'
   ~~~

   - pg를 쓰는 이유는 헤로쿠에서 지원하는 db이기 떄문
   - `bundle install --without production`

3. `model.rb` 파일에서 db 파일 수정

   ~~~ruby
   configure :development do
   DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/blog.db")
   end
   
   configure :production do
     DataMapper::setup(:default, ENV["DATABASE_URL"])
   end
   ~~~

   - ENV["DATABASE_URL"]은 heroku 서버에서 설정되어 있는 환경 변수.

4. `config.ru` 추가 -> 루트디렉토리에

   ~~~ruby
   require './app'
   run Sinatra::Application
   ~~~

   - 헤로쿠에서 서버를 실행하는 방법이 rake이기 떄문.

5. console에서 헤로쿠로 push

   `$hreoku login`

   `$ git add .`

   `$ git commit -m "msg"`

   `$ git push heroku master`
