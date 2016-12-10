require './lib/process_app'
require 'dotenv'
Dotenv.load if File.exist?(".env")

def tokens
  {
    bot_token: ENV["TELEGRAM_BOT_TOKEN"],
    access_token: ENV["ACCESS_TOKEN"],
    access_token_secret: ENV["ACCESS_TOKEN_SECRET"],
    consumer_key: ENV["CONSUMER_KEY"],
    consumer_secret: ENV["CONSUMER_SECRET"],
    database: ENV["DATABASE_URL"]
  }
end

def bot
  ProcessApp.new(tokens)
end

def run_proc
  last_meme = bot.get_last
  options = {}
  options = {count: 25, trim_user: true}
  options[:since_id] = last_meme[:tweetid] unless last_meme.nil?
  bot.process_timeline(ENV["TWITTERUSER"], options)
end

def post_memes
  10.times do
    bot.post(ENV["CHATID"])
    sleep(14)
  end
end

def main
  raise "No twitter user or Chat id" if ENV["TWITTERUSER"].nil? or ENV["CHATID"].nil?
  loop do
    run_proc
    post_memes
    sleep(360)
  end
end

main
