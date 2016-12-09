require 'spec_helper'
require 'meme_factory'
require 'twitter'


RSpec.describe MemeFactory do
  describe "tweet" do
    before do
      @tweet = Twitter::Tweet.new(id: 1, text: 'test', entities: {media: [{id: 1, type: 'photo'}]})
    end
    it "convert to meme object" do
      meme = MemeFactory.new(@tweet)
      expect(meme.text).to eql(@tweet.text)
      expect(meme.sourceid).to eql(@tweet.id)
      expect(meme.files.count).to be 1
    end
  end
end

