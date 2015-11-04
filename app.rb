require 'bundler/setup'
Bundler.require
Dotenv.load

require 'json'

get '/' do
  erb :index, :locals => {:message => "just a regular webeye... waiting for a webhook"}
end

post '/' do
  request.body.rewind
  payload = request.body.read
  if payload != nil && payload.to_s.strip.length > 0
    countries = JSON.parse payload
    qty_c = countries.length
    erb :index, :locals => {:message => "Parsed OK: #{qty_c} countries"}
  else
    400
  end
end

error 400 do
  'Expected countries.json payload in request body'
end
