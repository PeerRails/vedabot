require "vedabot"
require "vcr_test"

RSpec.describe VedaBot do
	describe "core function" do
		let(:bot){VedaBot.new("123:567")}

		it "#getme should get botname" do
			VCR.use_cassette('get_me') do
				reply = bot.getme
				expect(reply["ok"]).to be true
				expect(reply["result"]).not_to be nil
			end
		end

		it "#send_message should send message" do
			VCR.use_cassette('send_message') do
				message = {chat_id: -1001060312501, text: "Test"}
				reply = bot.send_message(message)
				expect(reply["ok"]).to be true
			end
		end

		it "#send_photo should send message with photo file" do
			VCR.use_cassette('send_photo') do
				message = {chat_id: -1001060312501, caption: "Test", photo: File.new("spec/support/test.png")}
				reply = bot.send_photo(message)
				expect(reply["ok"]).to be true
			end
		end
	
	end
end
