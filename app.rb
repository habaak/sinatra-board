#app.rb
require 'sinatra'
require 'sinatra/reloader'
require './model.rb'

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

get '/posts/:id' do #variable routing
    @id = params[:id]
    @post = Post.get(@id)
    erb :'posts/show'
end

get '/posts/destroy/:id' do
    @id = params[:id]
    Post.get(@id).destroy
    #erb :'posts/destroy'
    redirect '/posts'
end

# 수정하기
get '/posts/edit/:id' do
    @id = params[:id]
    @post = Post.get(@id)
    erb :'posts/edit'
end
# id를 받아와야함
# 값을 받아서 업데이트
get '/posts/update/:id' do
    @id = params[:id]
    Post.get(@id).update(title: params[:title], body: params[:body])
    # @post = Post.get(@id)
    # erb :'posts/update'
    redirect '/posts/'+@id
end