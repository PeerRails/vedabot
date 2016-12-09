require 'spec_helper'
require 'sequel'
require 'database'
require 'vedabot'
require 'tweet_watcher'
require 'process_app'
require 'vcr'

RSpec.describe ProcessApp do
  describe "main" do
    before do
      @tokens = {bot_token: "1",
      consumer_key: "2",
      consumer_secret: "3",
      access_token: "4",
      access_token_secret: "55555",
      database: ENV["DATABASE_URL"]}
      @client = ProcessApp.new(@tokens)
      @db = Sequel.connect(ENV['DATABASE_URL'])
      Dir.mkdir("/tmp/vedafiles") unless Dir.exist?("/tmp/vedafiles")
    end

    it "should process tweet" do
      tweet = Twitter::Tweet.new(id: 1, text: 'test', entities: {media: [{id: 1, type: 'photo'}]})
      process = lambda { @client.process_tweet(tweet) }
      process
      expect(@db[:memes].count).to be > 0
    end

    it "should process tweets" do
      tweets = [
        Twitter::Tweet.new(id: 1, text: 'test', entities: {media: [{id: 1, type: 'photo'}]}),
        Twitter::Tweet.new(id: 2, text: 'test2', entities: {media: [{id: 2, type: 'photo'}]}),
        Twitter::Tweet.new(id: 3, text: 'test', entities: {media: [{id: 3, type: 'photo'}]})]
      @client.process_tweets(tweets)
      expect(@db[:memes].count).to be > 3
    end

    it "should process timeline" do
      VCR.use_cassette("process_timeline") do
        @client.process_timeline("Ariiskie_vedi")
        expect(@db[:memes].count).to be > 20
      end
    end
  end
end
