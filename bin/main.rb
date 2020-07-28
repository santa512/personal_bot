#!/usr/bin/env ruby
require './lib/telegram/bot'
require './lib/Jokes'
require './lib/Messages'
require './lib/Quotes'


def background_run_at(time, message)
  fork do
    p time
    sleep(1) until Time.now.strftime('%R') == Time.new.strftime("#{time}")
    send_answer(message)
  end
end



def send_answer(message)
    token = '1261117312:AAFT9RGr5Dp-yhjdGD4yq7u_eTl45o2lQow'
    Telegram::Bot::Client.run(token) do |bot|
      bot.api.send_message(chat_id: message.chat.id, text: "#{DailyQuotes.request_quote}")
      sleep(60)
      form_response_again(message)
      
    end
end

def form_response_again(message)
  @num = message.text[7,12]
  unless @num.nil?
    background_run_at( @num , message)
    @str = "You will receive your daily quotes at #{@num[0,2]} hrs and #{@num[3,5]} min"
    # @str = sum([Time.now, 5])
  else
    @str = "Sorry I do not understand..."
  end
  return @str
end

def form_response_set(message)
  @num = message.text[7,12]
  unless @num.nil?
    background_run_at( @num , message)
    @str = "You will receive your daily quotes at #{@num[0,2]} hrs and #{@num[3,5]} min"
    # @str = sum([Time.now, 5])
  else
    @str = "Sorry I do not understand..."
  end
  return @str
end

token = '1261117312:AAFT9RGr5Dp-yhjdGD4yq7u_eTl45o2lQow'
Telegram::Bot::Client.run(token) do |bot|
  logger = Logger.new('logfile.log')
  bot.listen do |message|
    begin
    @keyword = message.text[/\/([a-zA-Z]+)/]
    rescue => err
      log.fatal(err)
      log.fatal(message.text)
    else
    case @keyword
      when '/daily'
        @reply = form_response_set(message)
        bot.api.send_message(chat_id: message.chat.id, text: @reply)
      when '/stop'
        bot.api.send_message(chat_id: message.chat.id, text: "Bye, #{message.from.first_name}")
      when '/end'
        bot.api.send_message(chat_id: message.chat.id, text: "Bye, #{message.from.first_name}")
    end

    case message.text
    when '/start'
      bot.api.send_message(chat_id: message.chat.id, text: "Hello, would you tell me you first name?")
    when ""+message.from.first_name.to_s+""
      bot.api.send_message(chat_id: message.chat.id, text: "Hi #{message.from.first_name}, "+ Jokes.request_joke)
    end
    end
  end
end