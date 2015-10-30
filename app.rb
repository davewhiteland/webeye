require 'bundler/setup'
Bundler.require
Dotenv.load

get '/' do
  erb :index, :locals => {:message => "just a regular webeye... waiting for a webhook"}
end

post '/webeye' do
  erb :index, :locals => {:message => "just caught a webhook!"}
end


