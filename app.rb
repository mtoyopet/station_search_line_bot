require 'sinatra'
require 'line/bot'
require 'net/http'
require 'json'
require './lib/heartrails'
require './lib/template'

get '/' do
  "HELLO WORLD!!!!!"  
end


def client
  @client ||= Line::Bot::Client.new {|config|
    config.channel_id = ENV["LINE_CHANNEL_ID"]
    config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
    config.channel_token = ENV["LINE_CHANNEL_ACCESS_TOKEN"]
  }
end

# おうむ返し用
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
        #文字をおうむ返しする
        message = {
          type: 'text',
          text: event.message['text']
        }
        client.reply_message(event['replyToken'], message)
      when Line::Bot::Event::MessageType::Sticker
        #ステッカーをおうむ返しする
        package_id = event.message['packageId']
        sticker_id = event.message['stickerId']

        message = {
            type: 'sticker',
            packageId: package_id,
            stickerId: sticker_id
        }

        client.reply_message(event['replyToken'], message)
      end
    end
  end
end

# 駅検索用
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
        if event.message['text'] =~ /駅/
          client.reply_message(event['replyToken'], current_location_template)
        elsif message = {
            type: 'text',
            text: event.message['text']
        }
          client.reply_message(event['replyToken'], message)
        end
      when Line::Bot::Event::MessageType::Location
        # event から 緯度経度のデータを取り出し
        longitude = event.message['longitude'] # 経度
        latitude = event.message['latitude'] # 緯度

        # 駅検索API呼び出し
        heartrails = Heartrails.new
        stations = heartrails.get_stations(longitude,latitude)

        text = stations[0..2].map do |station|
          station_str(station) + get_direction(latitude, longitude, "#{station['name']}駅")
        end

        message = {
            type: 'text',
            text: text.join("\n")
        }

        client.reply_message(event['replyToken'], message)
      end
    end
  end

  # Don't forget to return a successful response
  "OK"
end

def station_str(station)
  "#{station['line']} #{station['name']}駅 (#{station['distance']}メートル)\n"
end

def get_direction(latitude, longitude, destination)
  "GoogleMapはこちら\nhttps://www.google.com/maps/dir/?api=1&origin=#{latitude},#{longitude}&destination=#{destination}&mode=walking"
end