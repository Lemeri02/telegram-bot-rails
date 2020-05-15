require File.expand_path('../config/environment', __dir__)
require 'telegram/bot'

TOKEN = Rails.application.credentials.bot[:token]

Telegram::Bot::Client.run(TOKEN) do |bot|
  bot.listen do |message|

    case message.text
    when '/add'
      current_user = User.where(telegram_id: message.from.id).first_or_create do |user|
        user.username = message.from.username
      end
      bot.api.send_message(chat_id: message.chat.id, text: "Hi, I add User #{current_user.username}")
    when '/delete'
      bot.api.send_message(chat_id: message.chat.id, text: '/delete')
    end
  end
end
