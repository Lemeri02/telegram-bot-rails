require File.expand_path('../config/environment', __dir__)
require 'telegram/bot'

TOKEN = ENV['TOKEN'] || Rails.application.credentials.bot[:token]

Telegram::Bot::Client.run(TOKEN) do |bot|
  bot.listen do |message|

    kb = [
      Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Go to Google', url: 'https://google.com'),
      Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Touch me', callback_data: 'touch'),
      Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Switch to inline', switch_inline_query: 'some text')
    ]
    markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
    case message.text
    when '/add'
      current_user = User.where(telegram_id: message.from.id).first_or_create do |user|
        user.username = message.from.username
      end
      bot.api.send_message(chat_id: message.chat.id, text: "Hi, I add User #{current_user.username}", reply_markup: markup )
    when '/delete'
      bot.api.send_message(chat_id: message.chat.id, text: '/delete')
    end
  end
end
