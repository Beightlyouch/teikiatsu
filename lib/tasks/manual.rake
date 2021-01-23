require 'net/http'
require 'uri'
require 'json'

namespace :push_message do 
  desc "低気圧通知" 
  task kiatsu_alert: :environment do

    pressure = nil

    begin
      params = URI.encode_www_form({ lat: '35.681236', lon: '139.767125', units: 'metric', lang: "ja", appid: ENV["API_KEY"] })
      url = URI.parse("https://api.openweathermap.org/data/2.5/onecall?#{params}")
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      res = http.get(url)
      pressure = JSON.parse(res).dig("current", "pressure")
    rescue => e
    end

    message = {
      type: 'text',
      text: "今日の気圧は#{pressure}hPaです。注意しましょう"
    }

    client = Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }

    LineUser.all.each do |user|
      client.push_message(user.line_id, message)
    end
  end
end