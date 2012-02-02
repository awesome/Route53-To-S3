require 'spec_helper'
require './lib/configuration'

describe Configuration do
	before(:all) do
		Configuration.new('./spec/.route53_test')
		@config = Configuration
	end


	describe "aws properties"	do
		before(:all) do
			@aws = @config.aws
		end

		it "should be set" do
			@aws.should_not be_nil
		end

		it "should include 'access_key'" do
			@aws['access_key'].should_not be_nil
		end

		it "should include 'secret_key'" do
			@aws['secret_key'].should_not be_nil
		end
	end

	describe "s3 properties" do
		before(:all) do
			@s3 = @config.s3
		end

		it "should be set" do
			@s3.should_not be_nil
		end

		it "should include 'bucket'" do
			@s3['bucket'].should_not be_nil
		end

		it "should include 'upload_path'" do
			@s3['upload_path'].should_not be_nil
		end
	end

	describe "db properties" do
		before(:all) do
			@db = @config.db
		end

		it "should be set" do
			@db.should_not be_nil
		end

		it "should include 'location'" do
			@db['location'].should_not be_nil
		end

	end

	describe "daemon properties" do
		before(:all) do
			@daemon = @config.daemon
		end

		it "should be set" do
			@daemon.should_not be_nil
		end

		it "should include 'times'" do
			@daemon['times'].should_not be_nil
		end

		it "should include 'pid_path'" do
			@daemon['pid_path'].should_not be_nil
		end
	end
end
