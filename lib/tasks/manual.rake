namespace :push_message do 
  desc "低気圧通知" 
  task kiatsu_alert: :environment do
    message = {
      type: 'text',
      text: "今日は低気圧なので注意しましょう"
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