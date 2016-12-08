require 'vedabot'
require 'tweet_watcher'
require 'database'

class ProcessApp
  def initialize(tokens)
    @telega = VedaBot.new(tokens[:bot_token])
    @twee = TweetWatcher.new({access_token: tokens[:access_token],
                              access_token_secret: tokens[:access_token_secret],
                              consumer_key: tokens[:consumer_key],
                              consumer_secret: tokens[:consumer_secret]})
    @db = DatabaseAdapter.new(tokens[:database])
  end

  def process_timeline(user)
    @since_id = nil if @since_id.nil?
    tweets = @twee.user_timeline(user, {since_id: @since_id, count: 100, trim_user: true})
    process_tweets(tweets)
  end

  def process_tweets(tweets)
    return false if tweets.empty?
    head, *tail = tweets
    process_tweet(head) unless head.nil?
    process_tweets(tail) unless tail.nil?
  end

  def process_tweet(tweet)
    raise NotImplementedError
    # Prepare source
    # add to queue
    # exit
  end
end
