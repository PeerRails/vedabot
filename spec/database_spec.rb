require 'spec_helper'
require 'database'
require 'sequel'

RSpec.describe DatabaseAdapter do
  describe "initialize" do
    before do
      @db = Sequel.connect(ENV['DATABASE_URL'])
    end
    let(:db){ DatabaseAdapter.new(ENV['DATABASE_URL']) }
    it "should migrate new data" do
      @db.run 'DROP TABLE IF EXISTS "memes"'
      db = DatabaseAdapter.new(ENV['DATABASE_URL'])
      expect(@db.table_exists?(:memes)).to eql(true)
    end
    it "should add record to memes" do
      source = {tweetid: 123456, text: "caption", filepath: "damn", queue: true}
      result = db.add_meme(source)
      expect(result).to eql(1)
      expect(@db[:memes].first(id: result)).not_to be nil?
    end
    it "should return meme" do
      source = {tweetid: 1234567, text: "caption", filepath: "damn", queue: true}
      row = db.add_meme(source)
      expect(db.get_meme(row)[:tweetid]).to eql(source[:tweetid])
    end
    it "should get next in que" do
      source = {tweetid: 432123, text: "two", filepath: "damn"}
      db.add_meme({tweetid: 123456, text: "caption", filepath: "damn", queue: true})
      db.add_meme(source)
      que = db.next_que
      expect(que[:queue]).to be true
      expect(que[:tweetid]).to eq(123456)
    end
    it "should remove from queue" do
      source = {tweetid: 4321232, text: "two", filepath: "damn"}
      id = db.add_meme(source)
      db.remove_que(id)
      expect(db.get_meme(id)[:queue]).to be false
    end
    it "should get queue" do
      source = {tweetid: 4321233, text: "two", filepath: "damn"}
      db.add_meme({tweetid: 123456, text: "caption", filepath: "damn", queue: true})
      db.add_meme(source)
      queue = db.get_que
      expect(queue.count).to be > 2 
    end

    it "should get last meme" do
      source = {tweetid: 4333333, text: "last", filepath: "damn_lost"}
      db.add_meme(source)
      expect(db.last_meme[:text]).to eql("last")
    end

    it "should not save dubs" do
      source = {tweetid: 123456, text: "dubs", filepath: "create_new"}
      db.add_meme(source)
      expect{db.add_meme(source)}.to change{@db[:memes].count}.by(0)
    end

  end
end
