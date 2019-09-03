require 'net/http'
require 'json'

class Heartrails
  attr_accessor :longitude, :latitude
  @@uri_base = 'http://express.heartrails.com/api/json'

  def get_stations(longitude, latitude)
    uri = URI.parse("#{@@uri_base}")
    uri.query = URI.encode_www_form(
      method: 'getStations',
      x: longitude,
      y: latitude
    )
    res = Net::HTTP.get_response(uri)
    JSON.parse(res.body)['response']['station']
  end
end