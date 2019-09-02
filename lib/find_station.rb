require 'net/http'
require 'json'
require 'uri'

def station_api(longitude, latitude, postal)
  uri = URI.parse 'http://geoapi.heartrails.com/api/json?method=getStations'

  # リクエストの送信
  uri.query = URI.encode_www_form({
    method: "getStations",
    postal: URI::encode(postal)
    # x: longitude,
    # y: latitude
    })
  res = Net::HTTP.get_response(uri)
  station = JSON.parse(res.body)["response"]["station"]

  puts JSON.parse(res.body)["response"]["station"][0]["name"]
end

# station_api("35.7127", "139.7620", "1520013")
