require 'sinatra'
require 'line/bot'
require 'net/http'
require 'json'
require './lib/find_station'
require './lib/template'

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
        if event.message['text'] =~ /駅/
         client.reply_message(event['replyToken'], template)
        elsif
          message = {
            type: 'text',
            text: event.message['text']
          }
          client.reply_message(event['replyToken'], message)
        end
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

        longitude = event.message['longitude']
        latitude = event.message['latitude']

        result = station_api(longitude, latitude)

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
