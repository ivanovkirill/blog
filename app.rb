require "sinatra"
require "sinatra/activerecord"
require "sinatra/flash"
#require "digist/md5" 

Dir.glob("./models/*.rb") do |rb_file|
  require "#{rb_file}"
end

set :database, "sqlite3:///db/blog.sqlite3"
set :sessions, true

helpers do
  def pretty_date(time)
    time.strftime("%d %b %Y")
  end

  def post_show_page?
    request.path_info =~ /\/posts\/\d+$/
  end

  def delete_post_button(post_id)
    erb :_delete_post_button, locals: {post_id: post_id}
  end

  def user_here?
      session[:user]!=nil
  end

end

# before "/" do
#   if session[:user]!=nil
#   redirect "/"
#   else
#   redirect "/registrate"
#   end
# end

# before "/posts/:id/edit" do 
#   unless user_here? && @post.session[:user].id==session[:user].id
#     redirect "/sign_in"
#   end
# end

# before "/posts/new" do
#    unless user_here? && @post.session[:user].id==session[:user].id
#     redirect "/sign_in"
#   end
# end

get "/" do 
  @posts = Post.order("created_at DESC")
  erb :"posts/index"
end

get "/posts/new" do 
  @title = "New Post"
  if user_here?
    @post = Post.new
    erb :"posts/new"
  else
    flash.now[:error] = "Login pls"
  end
end

post "/posts" do  
  @post = Post.new(params[:post])
  @post.user_id = session[:user].id
  if @post.save
    redirect "posts/#{@post.id}"
  else
    erb :"posts/new"
  end
end

get "/posts/:id" do 
  @post = Post.find(params[:id])
  erb :"posts/show"
end

get "/posts/:id/edit" do 
  @post = Post.find(params[:id])
  @title = "Edit Form"
  if user_here? && @post.user.id == session[:user].id
    erb :"posts/edit"
  else
    flash.now[:error] = "U can't edit enemy post"
  end
end

put "/posts/:id" do 
  @post = Post.find(params[:id])
  if @post.update_attributes(params[:post])
    redirect "/posts/#{@post.id}"
  else
    erb :"posts/edit"
  end
end
 
delete "/posts/:id" do 
  if user_here? && @post.user.id == session[:user].id
    @post = Post.find(params[:id])
    @post.comments.each do |comment|
      comment.destroy
    end
    @post = Post.find(params[:id]).destroy
    redirect "/"
  else
    flash.now[:error] = "bla bla bla"
  end
end

post "/posts/:id/comments" do 
  @comment = Comment.new(
    body: params[:comment_body],
    user_id: session[:user].id,
    post_id: params[:id]
    )
  if @comment.save
    redirect "posts/#{@comment.post_id}"
  else
    erb :"pages/register"
  end
end

delete "/posts/:id/comments/:comment_id" do
  @comment = Comment.find(params[:comment_id]).destroy
  redirect "/posts/#{params[:id].to_s}"
end

get '/registrate' do 
  erb :"pages/registrate"
end

post '/registrate' do 
  @user = User.new(params[:user])
  if @user.save
    redirect "/sign_in"
  else
    erb :"pages/registrate"
  end
end

get '/sign_in' do 
  erb :"/pages/sign_in"   
end

post '/sign_in' do 
  @user = User.find_by_email(params[:email])
  if @user && @user.password == params[:password]
    session[:user] = @user
    redirect "/"
  else
    flash.now[:error] = "Something wrong with sign_in, try again"
    # redirect '/'
  end
end

get '/sign_out' do 
  session[:user] = nil
  redirect '/'
end

get "/about_me" do 
  @title = "About Me"
  @user = session[:user]
  erb :"pages/about_me"
end

not_found do
  status 404
  erb :"pages/not_found"
end