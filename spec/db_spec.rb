require 'spec_helper'
require './lib/db'

describe DB do
	before(:all) do
		Configuration.new('./spec/.route53_test')
		@config = Configuration.db
		@db = DB.new
	end

	# Delete the database after the test if the database was 
	# successfully created.
	after(:all) do
		if File.exists?(@config['location'])
			File.delete(@config['location'])
		end
	end

	describe "initilaize" do
		it "should return a DB object" do
			@db.should_not be_nil
		end
	end

	describe "#create" do
		it "should create a database at the path specified in the config file" do
			File.exists?(@config['location']).should be_true
		end
	end
end
