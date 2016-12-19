require 'rubygems'
require 'sinatra'
require 'sqlite3'

def init_db
  @db = SQLite3::Database.new 'blog.db'
  @db.results_as_hash = true
end

before do
  init_db
end

configure do
  init_db
  @db.execute 'CREATE TABLE IF NOT EXISTS Posts
    (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      created_date DATE,
      username TEXT,
      content TEXT
    )'
end

get '/' do
  @posts = @db.execute 'SELECT * FROM Posts order by id desc'
  erb :index
end

get '/new' do
  erb :new
end

post '/new' do
  username = params[:username]
  content = params[:content]

  @db.execute 'INSERT INTO Posts
  (created_date, username, content) values (datetime(), ?, ?)', [username, content]

  # проверка на пустные поля
  if username.strip.empty?
    @error = "Please type your NAME"
    return erb :new
  end
  if content.strip.empty?
    @error = "Please type your TEXT"
    return erb :new
  end


  redirect to '/'
end





########
helpers do
  def username
    session[:identity] ? session[:identity] : 'Hello stranger'
  end
end
