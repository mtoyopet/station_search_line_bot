def get_direction(latitude, longitude, destination)
  puts "https://www.google.com/maps/dir/?api=1&origin=#{latitude},#{longitude}&destination=#{destination}"
end

get_direction(34.393294, 132.488368, "広島駅")