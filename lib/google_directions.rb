require 'net/http'
require 'json'

class GoogleDirections
  def get_direction_api(longitude, latitude, destination)
    url = "https://maps.googleapis.com/maps/api/directions/json"

    uri = URI.parse("#{url}")
    uri.query = URI.encode_www_form(
      origin: "#{latitude},#{longitude}",
      key: 'AIzaSyCkCjc32eqW_DgiTXLQPLbIDvRIXgqQwKw',
      destination: destination
    )

    res = Net::HTTP.get_response(uri)
    puts JSON.parse(res.body)
  end

  def get_direction(longitude, latitude, destination)
    "https://www.google.com/maps/dir/?api=1&origin=#{longitude},#{latitude}&destination=#{destination}"
  end
end


g = GoogleDirections.new
g.get_direction(139.702759,35.679600,"代々木駅")