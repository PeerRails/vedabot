require "spec_helper"
require "tweet_watcher"
require "vcr_test"

RSpec.describe TweetWatcher do

	describe "#read_timeline" do
		let(:tokens){{
			consumer_key: "1",
			consumer_secret: "2",
			access_token: "3",
			access_token_secret: "4"}}
		let(:watcher){TweetWatcher.new(tokens)}

		it "should read timeline of user" do
			VCR.use_cassette("user_timeline") do
				timeline = watcher.user_timeline("Ariiskie_vedi")
				expect(timeline.count).to eql(20)
			end
		end
		
		it "should read timeline of user since this id" do
			VCR.use_cassette("user_timeline_since_id") do
				timeline = watcher.user_timeline("Ariiskie_vedi", {since_id: 805306097091362816})
				expect(timeline.count).to be > 0
			end
		end
	end
end

