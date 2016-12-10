require 'simplecov'

ENV["DATABASE_URL"] ||= "postgres://test:test@localhost/vedabot_test"
SimpleCov.start do
	add_filter "spec/vcr_test.rb"
end

