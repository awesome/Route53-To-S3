require 'spec_helper'
require './lib/route53backup'

describe Route53Backup do
	before(:all) do
		Configuration.new('./spec/.route53_test')
		@config = Configuration
		@db = DB.new
		@zone = sample_zone
		@record = sample_record
	end

	# Delete the database after the test if the database was 
	# successfully created.
	after(:all) do
		if File.exists?(@config.db['location'])
			File.delete(@config.db['location'])
		end
	end

	describe ".connect" do
		it "should establish an S3 connection" do
			Route53Backup.connect(@db, [@zone]).should_not be_nil
		end
	end

	describe ".populate_db" do
		before(:all) do
			Route53Backup.populate_db
		end

		it "should create a database at the path specified in the config file" do
			File.exists?(@config.db['location']).should be_true
		end

		it "should create a table for a zone's entries" do
			zone_table_created(@db, @zone).should be_true
		end

		it "should populate a zone's tables with records" do
			find_record_entry(@db, @zone, @record).should_not be_empty
		end
	end


end
