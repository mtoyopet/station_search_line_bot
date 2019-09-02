require 'net/http'
require 'json'
require 'uri'

def station_api(longitude, latitude)
  uri = URI.parse 'http://express.heartrails.com/api/json?method=getStations'

  # リクエストの送信
  uri.query = URI.encode_www_form({
    method: "getStations",
    x: longitude,
    y: latitude
    })

  res = Net::HTTP.get_response(uri)

  if JSON.parse(res.body)["response"]["station"].count > 1
    station = JSON.parse(res.body)["response"]["station"][0]

    name = station['name']
    line = station['line']
    distance = station['distance']

    return "#{line}　#{name}駅 (#{distance}メートル)"
  end
end

station_api("134.997633", "35.002069")
