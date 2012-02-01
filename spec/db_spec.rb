require 'spec_helper'
require 'ostruct'
require './lib/db'
require './lib/dns'

describe DB do
	before(:all) do
		Configuration.new('./spec/.route53_test')
		@config = Configuration.db
		@db = DB.new

		# Create pretend zone/record objects. 
		@zone = OpenStruct.new({
			:name => "somedomain.com",
			:host_url => "/hostedzone/LOL123"
		})

		@record = OpenStruct.new({
			:name => "www.somedomain.com",
			:type => "CNAME",
			:ttl => 900,
			:values => ["ns-1741.awsdns-25.co.uk.", 
									"ns-1092.awsdns-08.org.", 
									"ns-950.awsdns-54.net.", 
									"ns-331.awsdns-41.com."] 
		})
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
			result = @db.db.execute <<-SQL
				SELECT * from zones
				WHERE domain='#{@zone.name}' AND
				zone_id='#{@db.zone_id(@zone)}'
			SQL
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
			tableExists=true
			begin
				@db.db.execute <<-SQL
					select * from #{@db.clean_zone_name(@zone)}
				SQL
			rescue SQLite3::SQLException => e
				if e.message =~ /no such table/i
					tableExists=false
				end
			end

			tableExists.should be_true
		end
	end
end
