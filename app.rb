require 'process_app'

def tokens
  {
    bot_token: ENV["TELEGRAM_BOT_TOKEN"],
    access_token: ENV["ACCESS_TOKEN"],
    access_token_secret: ENV["ACCESS_TOKEN_SECRET"],
    consumer_key: ENV["CONSUMER_KEY"],
    consumer_secret: ENV["CONSUMER_SECRET"]
  }
end

def bot
  ProcessApp.new(tokens)
end

def run_proc
  bot.process_timeline(ENV["TWITTERUSER"])
end

def main
  loop do
    run_proc
    sleep(3600)
  end
end

