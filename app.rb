require 'sinatra'
require 'line/bot'
require 'net/http'
require 'json'
require './lib/heartrails'
require './lib/template'

def client
  @client ||= Line::Bot::Client.new {|config|
    config.channel_id = ENV["LINE_CHANNEL_ID"]
    config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
    config.channel_token = ENV["LINE_CHANNEL_ACCESS_TOKEN"]
  }
end

post '/callback' do
  body = request.body.read

  signature = request.env['HTTP_X_LINE_SIGNATURE']
  unless client.validate_signature(body, signature)
    error 400 do
      'Bad Request'
    end
  end

  events = client.parse_events_from(body)
  events.each do |event|
    case event
    when Line::Bot::Event::Message
      case event.type
      when Line::Bot::Event::MessageType::Text
        if event.message['text'] == "にゃん"
          message = {
            type: 'text',
            text: "にゃん"
          }
          client.reply_message(event['replyToken'], message)
        else
          message = {
            type: 'text',
            text: event.text['message']
          }
          client.reply_message(event['replyToken'], message)

        end
      end
    end
  end
end

def station_str(station)
  "#{station['line']} #{station['name']}駅 (#{station['distance']}メートル)\n"
end

def get_direction(longitude, latitude, destination)
  "GoogleMapはこちら\nhttps://www.google.com/maps/dir/?api=1&origin=#{longitude},#{latitude}&destination=#{destination}&mode=walking"
end