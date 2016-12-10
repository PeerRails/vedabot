require 'vedabot'
require 'tweet_watcher'
require 'database'
require 'meme_factory'
require 'open-uri'

class ProcessApp
  def initialize(tokens)
    @tokens = tokens
  end

  # Process user's timeline
  # @param user [String] username
  # @param options [Hash] map of options
  def process_timeline(user, options={count: 25, trim_user: true})
    tweets = twitter.user_timeline(user, options)
    process_tweets(tweets)
  end

  # Process list of tweets recursively
  # @param tweets [Array]
  def process_tweets(tweets)
    return false if tweets.empty?
    head, *tail = tweets
    process_tweet(head) unless head.nil?
    process_tweets(tail) unless tail.nil?
  end

  # Process tweet
  # @param tweet [Hash|Tweet]
  def process_tweet(tweet)
    return false if tweet.nil?
    meme = prepare_source(tweet)
    add_to_queue( meme )
  end

  # Download file from url
  # @param url [String]
  # @return path [String]
  def file_download(url)
    return "" if url.nil? || url.empty?
    path = "/tmp/vedafiles/#{url.split('/').last}"
    File.open(path, "wb") do |file|
      file.write open(url).read
    end
    return path
  end

  # Post meme to destination (telegram)
  # from database queue
  # @param chatid [Integer]
  def post(chatid)
    meme = db.next_que
    unless meme.nil? or !File.exist?(meme[:filepath])
      message = {chat_id: chatid, photo: File.new(meme[:filepath])}
      telegram.send_photo(message)
    end
    db.remove_que(meme[:id])
  end

  private

    # Adapt source for adding to database
    # @param source [any]
    # @return [Hash]
    def prepare_source(source)
      meme = MemeFactory.new(source)
      file = file_download(meme.files[0])
      return {
        text: meme.text,
        filepath: file,
        tweetid: meme.sourceid
      }
    end

    # Add to queue parsed source
    # @param item [Hash]
    # @return rowid [Integer]
    def add_to_queue(item)
      db.add_meme(item)
    end

    # Get VedaBot (Telegram) connection
    def telegram
      VedaBot.new(@tokens[:bot_token])
    end

    # Get TweetWatcher (Twitter) connectrion
    def twitter
      TweetWatcher.new({access_token: @tokens[:access_token],
                              access_token_secret: @tokens[:access_token_secret],
                              consumer_key: @tokens[:consumer_key],
                              consumer_secret: @tokens[:consumer_secret]})
    end

    # Get DatabaseAdapter (Database) connection
    def db
      DatabaseAdapter.new(@tokens[:database])
    end
end
