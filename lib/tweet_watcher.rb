require 'twitter'

class TweetWatcher
	def initialize(tokens={})
		raise "No token" if tokens.nil? || tokens.empty?
		@client = Twitter::REST::Client.new do |config|
			config.consumer_key        = tokens[:consumer_key]
			config.consumer_secret     = tokens[:consumer_secret]
			config.access_token        = tokens[:access_token]
			config.access_token_secret = tokens[:access_token_secret] 
		end
	end

	def user_timeline(user, options={})
		return false if user.nil? || user.empty?
		@client.user_timeline(user, options)
	end
end
