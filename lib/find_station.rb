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
  stations = JSON.parse(res.body)["response"]["station"]

  result = stations.map { |station| "#{station['line']} #{station['name'}駅 (#{station['distance']}メートル)"}.join("\n")

  return result
end
