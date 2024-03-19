require 'rubygems'
require 'sinatra'

configure do
  enable :sessions
end

helpers do
  def username
   session[:identity] ? session[:identity] : ''
  end
end


before '/secure/*' do
  unless session[:identity]
    session[:previous_url] = request.path
    @error = 'Sorry, you need to be logged in to visit ' + request.path
    halt erb(:login_form)
  end
end

get '/' do
 erb 'Can you handle a <a href="/secure/place">secret</a>?'
end

get '/login/form' do
  erb :login_form
end

post '/login/attempt' do
  session[:identity] = params['username']
  where_user_came_from = session[:previous_url] || '/'
  redirect to where_user_came_from
end

get '/logout' do
  session.delete(:identity)
  erb "<div class='alert alert-message'>Logged out</div>"
end

get '/secure/place' do
  erb 'This is a secret place that only <%=session[:identity]%> has access to!'
end

get '/about' do
  erb :about
end

get '/contacts' do
  erb :contacts
end

get '/visite' do
  erb :visite
end


post '/visite' do
  @user_name = params[:@user_name]
  @phone = params[:@phone]
  @time = params[:@time]
  @barber = params[:@barber]
  @color = params[:@color]

  @title = "Спасибо!"
  @message = "#{@user_name}, мы будем ждать вас #{@time} к барберу #{@barber}, цвет #{@color}"

  f = File.open 'client.txt', 'a' # образует запись в файл, а - добавляет в конец файла
      f.write "
Клиент: #{@user_name} === телефон: #{@phone} === дата/время: #{@time} === барбер: #{@barber} === цвет #{@color}"
      f.close
  erb :message
end




