require 'spec_helper'
require './lib/db'
require './lib/dns'

describe DB do
	before(:all) do
		Configuration.new('./spec/.route53_test')
		@config = Configuration.db
		@db = DB.new
		@zone = sample_zone
		@record = sample_record

	end

	# Delete the database after the test if the database was 
	# successfully created.
	after(:all) do
		if File.exists?(@config['location'])
			File.delete(@config['location'])
		end
	end

	describe "#create" do
		it "should create a database at the path specified in the config file" do
			@db.create
			File.exists?(@config['location']).should be_true
		end
	end

	describe "#zone_id" do
		it "should return the zone's zone id" do
			@db.zone_id(@zone).should eq("LOL123")
		end
	end

	describe "#add_zone" do
		it "should create a zone entry" do
			@db.add_zone(@zone)

			# Attempt to find the zone added
			result = find_zone_entry(@db, @zone)
			result.should_not be_empty

		end
	end

	describe "#clean_zone_name" do
		it "should replace all non-alphanumeric characters with underscores" do
			@db.clean_zone_name(@zone).should eq("somedomain_com")
		end
	end

	describe "#create_zone_table" do
		it "should create a table for the specified zone" do
			@db.create_zone_table(@zone)

			# Try to select something from the newly created table.
			zone_table_created(@db, @zone).should be_true
		end
	end

	describe "#join_values" do
		it "should join values together by commas" do
			joinedString = "ns-1741.awsdns-25.co.uk.,ns-331.awsdns-41.com." 
			@db.join_values(@record).should eq(joinedString)
		end
	end

	describe "#add_record" do
		it "should add a record to the provided zone" do
			@db.add_record(@record, @zone)
			find_record_entry(@db, @zone, @record).should_not be_empty
		end
	end
end
