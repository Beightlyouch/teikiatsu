class LineBotController < ApplicationController
  require 'line/bot'

  # callbackアクションのCSRFトークン認証を無効
  protect_from_forgery :except => [:callback]

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end

  def callback
    body = request.body.read

    # signature = request.env['HTTP_X_LINE_SIGNATURE']
    # unless client.validate_signature(body, signature)
    #   head :bad_request
    # end

    events = client.parse_events_from(body)

    events.each { |event|
      case event["type"]
      when "follow"
        follow_event(event)
      end
    }

    # 本当は非同期で行う
    render status: 200, json: { status: 200, message: "Success" }
  end

  def follow_event(event)
    line_id = event["source"]["userId"]
    LineUser.create!(line_id: line_id)
  end
end
