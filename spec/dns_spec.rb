require 'spec_helper'
require './lib/dns'

describe DNS do
	before(:all) do
		Configuration.new('./spec/.route53_test')
		@config = Configuration
		DNS.connect

		# Althought putting @zones here isn't following best practice,
		# since it requires a large amount of data transfer, we'll make an exception
		@zones = DNS.zones
	end


	describe ".zones" do
		it "should list the DNS zones" do
			@zones.should_not be_empty
		end
	end

	describe ".records" do
		it "should list the DNS records for a zone" do
			DNS.records(@zones.first).should_not be_empty
		end
	end


end
