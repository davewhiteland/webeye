require 'bundler/setup'
Bundler.require
Dotenv.load

require 'json'
require 'open-uri'

EP_ROOT_URL = 'http://rawgit.com/everypolitician/everypolitician-data'

get '/' do
  erb :index, :locals => {:message => "just a regular webeye... waiting for a webhook"}
end

post '/' do
  request.body.rewind
  payload = request.body.read
  if payload != nil && payload.to_s.strip.length > 0
    countries = JSON.parse payload
    debug_text = ""
    all_names = []
    for country in countries

      #=========================================
      # FIXME DEBUG: only do the Vatican for now (because: small data set)
      # FIXME DEBUG: otherwise this is a lot of activity every time it's run
      next unless country['name'].include? 'Vatican'
      #=========================================

      for legislature in country['legislatures']
        sha = legislature['sha']
        # has the SHA changed since "last time"? TODO
        url = "#{EP_ROOT_URL}/#{sha}/#{legislature['popolo']}"
        popolo_json = open(url).read
        popolo = JSON.parse(popolo_json)
        for person in popolo['persons']
          debug_text += "#{country['name']}: #{person['id']}, #{person['name']}\n"
        end
      end
    end
    qty_c = countries.length
    erb :index, :locals => {:message => "Parsed OK: #{qty_c} countries", :debug_text => debug_text}
  else
    400
  end
end

error 400 do
  'Expected countries.json payload in request body'
end
