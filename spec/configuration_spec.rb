require 'spec_helper'
require './lib/configuration'

describe Configuration do
	before(:each) do
		Configuration.new('./spec/.route53_test')
		@config = Configuration
	end


	describe "aws properties"	do
		before(:each) do
			@aws = @config.aws
		end

		it "should be set" do
			@aws.should_not be_nil
		end

		it "should include access_key" do
			@aws['access_key'].should_not be_nil
		end

		it "should include secret_key" do
			@aws['secret_key'].should_not be_nil
		end
	end

	describe "s3 properties" do
		before(:each) do
			@s3 = @config.s3
		end

		it "should be set" do
			@s3.should_not be_nil
		end

		it "should include bucket" do
			@s3['bucket'].should_not be_nil
		end

		it "should include upload_path" do
			@s3['upload_path'].should_not be_nil
		end
	end
end
