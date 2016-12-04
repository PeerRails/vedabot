require "telegram/bot"

class VedaBot
	def initialize(token=nil)
		raise "null token" if token.nil? or token.empty?
		@token = token
	end
	
	def getme
		client.get_me
	end

	def send_message(message={chat_id: nil, text: nil})
		return false if message.nil? || message[:chat_id].nil? || message[:text].nil? 
		client.send_message(message)
	end

	def send_photo(message={chat_id: nil, caption: nil, photo: File.new})
		return false if message.nil? || message[:chat_id].nil? || message[:photo].nil?
		client.send_photo(message)
	end

	private
		def client
			Telegram::Bot::Client.new(@token)
		end
end
