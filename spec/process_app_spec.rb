require 'spec_helper'
require 'database'
require 'vedabot'
require 'tweet_watcher'
require 'process_app'

RSpec.describe ProcessApp do
  describe "main" do
    before do
      @tokens = {bot_token: "",
      consumer_key: "",
      consumer_secret: "",
      access_token: "",
      access_token_secret: "",
      database: ENV["DATABASE_URL"]}
    end

    it "should process_timeline" do
      #client = ProcessApp.new(@tokens)
      #expect{ client.process_tweet }.to raise_error NotImplementedError
    end
  end
end
