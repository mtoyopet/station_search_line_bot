require 'net/http'
require 'json'

def get_stations(latitude, longitude)
  uri_base = 'http://express.heartrails.com/api/json'
  uri = URI.parse("#{uri_base}")
  uri.query = URI.encode_www_form(
    method: 'getStations',
    x: longitude,
    y: latitude
  )
  res = Net::HTTP.get_response(uri)
  puts JSON.parse(res.body)
  
  JSON.parse(res.body)['response']['station']
end

get_stations(34.396180, 132.507412)
