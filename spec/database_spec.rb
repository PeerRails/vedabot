require 'spec_helper'
require 'database'
require 'sequel'

RSpec.describe Database do
  describe "initialize" do
    before do
      @db = Sequel.connect(ENV['DATABASE_URL'])
      @db.run 'DROP TABLE IF EXISTS "memes"'
    end
    it "should migrate new data" do
      db = Database.new(ENV['DATABASE_URL'])
      expect(@db.table_exists?(:memes)).to eql(true)
    end
    it "should add record to memes" do
      source = {tweetid: 123456, text: "caption", filepath: "damn", queue: true}
      db = Database.new(ENV['DATABASE_URL'])
      db.add_meme(source)
      expect(@db[:memes].first).not_to be nil? 
    end
    it "should return meme" do
      source = {tweetid: 123456, text: "caption", filepath: "damn", queue: true}
      db = Database.new(ENV['DATABASE_URL'])
      row = db.add_meme(source)
      expect(db.get_meme(row)[:tweetid]).to eql(source[:tweetid])
    end
    it "should get next in que" do
      source = {tweetid: 432123, text: "two", filepath: "damn"}
      db = Database.new(ENV['DATABASE_URL'])
      db.add_meme({tweetid: 123456, text: "caption", filepath: "damn", queue: true})
      db.add_meme(source)
      que = db.next_que
      expect(que[:queue]).to be true
      expect(que[:tweetid]).to eq(123456)
    end
    it "should remove from queue" do
      source = {tweetid: 432123, text: "two", filepath: "damn"}
      db = Database.new(ENV['DATABASE_URL'])
      id = db.add_meme(source)
      db.remove_que(id)
      expect(db.get_meme(id)[:queue]).to be false
    end
    it "should get queue" do
      source = {tweetid: 432123, text: "two", filepath: "damn"}
      db = Database.new(ENV['DATABASE_URL'])
      db.add_meme({tweetid: 123456, text: "caption", filepath: "damn", queue: true})
      db.add_meme(source)
      queue = db.get_que
      expect(queue.count).to eql(2)
    end

  end
end