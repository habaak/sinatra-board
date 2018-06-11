#app.rb
gem 'json','~> 1.6'

require 'sinatra'
require 'sinatra/reloader'
require 'data_mapper' # metagem, requires common plugins too.

#DataMapper Log 찍기
DataMapper::Logger.new($stdout,:debug)
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



before do 
    p "----------------------"
    p params
    p "----------------------"
end

get '/' do
    send_file 'views/index.html'
end

get '/lunch' do
    arr  = ['20층 A','20층 B','칼국수','서브웨이','한솥','백종원 본가','중국집','돈까스']
    arr2 = ['시원한','얼큰한','JMT','깊은 맛','며느리도 울고갈','30년 전통','가성비']
    @abj = arr2.sample
    @lunch = arr.sample
    erb :lunch
end

#게시글을 모두 보여주는 곳
get '/posts' do
    #@posts = Post.all.reverse
    @posts = Post.all(:order => [:id.desc])#Symbol로 처리하여 속도를 높힌다.
    erb :'posts/posts'
end

#게시글을 쓸 수 있는 곳
get '/posts/new' do
    erb :'posts/new'
end


get '/posts/create' do
    @title = params[:title]
    @body = params[:body]
    Post.create(title: @title, body: @body)
    erb :'posts/create'
end