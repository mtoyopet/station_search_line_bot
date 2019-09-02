require 'sinatra'
require 'line/bot'
require 'net/http'
require 'json'

def station_api(longitude, latitude)
  uri = URI.parse 'http://geoapi.heartrails.com/api/json?method=getStations'

  # リクエストの送信
  uri.query = URI.encode_www_form({
    q: "get_nearest_station",
    x: longitude,
    y: latitude
    })
  res = Net::HTTP.get_response(uri)
  JSON.parse(res.body)["response"]["station"]
end


def client
  @client ||= Line::Bot::Client.new { |config|
    config.channel_id = ENV["LINE_CHANNEL_ID"]
    config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
    config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
  }
end

post '/callback' do
  body = request.body.read

  signature = request.env['HTTP_X_LINE_SIGNATURE']
  unless client.validate_signature(body, signature)
    error 400 do 'Bad Request' end
  end

  events = client.parse_events_from(body)
  events.each do |event|
    case event
    when Line::Bot::Event::Message
      case event.type
      when Line::Bot::Event::MessageType::Text
        message = {
          type: 'text',
          text: event.message['text']
        }
        client.reply_message(event['replyToken'], message)
      when Line::Bot::Event::MessageType::Sticker
        package_id = event.message['packageId']
        sticker_id = event.message['stickerId']

        message = {
          type: 'sticker',
          packageId: package_id,
          stickerId: sticker_id
          }

        client.reply_message(event['replyToken'], message)
      when Line::Bot::Event::MessageType::Location

        result = station_api(event.message['longitude'], event.message['latitude'])

        message = {
          type: 'text',
          text: result
          }

        client.reply_message(event['replyToken'], message)
      when Line::Bot::Event::MessageType::Image, Line::Bot::Event::MessageType::Video
        response = client.get_message_content(event.message['id'])
        tf = Tempfile.open("content")
        tf.write(response.body)
      end
    end
  end

  # Don't forget to return a successful response
  "OK"
end
