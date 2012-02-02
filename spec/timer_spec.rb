require 'spec_helper'
require './lib/timer'
require 'chronic'

##############################################################
# NOTE: A new @timer object should be instantiated for tests
# that alter properties.
##############################################################
describe Timer do
	before(:all) do
		Configuration.new('./spec/.route53_test')
		@timeList = ['05:45', '09:30', '15:00']
		@timer = Timer.new(@timeList)
	end

	describe "initialization" do
		it "should create a Timer object" do
			@timer.should_not be_nil
		end

		it "should have an accessible 'times' attribute" do
			@timer.times.should_not be_nil
		end
	end

	describe "#shift_time" do
		it "should shift the first time slot to the last" do
			@timer = Timer.new(@timeList)
			newTimeList = ['09:30', '15:00', '05:45']
			@timer.shift_time
			@timer.times.should eq(newTimeList)
		end
	end

	describe "#upcoming_time" do
		it "should return the first time entry as a Time object" do
			upcomingTime = @timer.upcoming_time

			# Make sure we got the first entry
			upcomingTime.to_s.should eq("2012-02-03 05:45:00 -0600")

			# Make sure it's a Time object so we can do operations on it
			upcomingTime.class.should eq(Time)
		end
	end

	describe "#ready_for_upload?" do
		describe "if current time < upcoming time" do
			it "should return false" do
				# Fake a current time
				currentTime = Chronic::parse("05:40")
				@timer.ready_for_upload?(currentTime).should be_false
			end
		end

		describe "if current time >= upcoming time" do
			# We want to share the timer object between the
			# two tests
			before(:all) do
				@timer = Timer.new(@timeList)
				@currentTime = Chronic::parse("07:40")
			end

			it "should return true" do
				# Fake a current time
				@timer.ready_for_upload?(@currentTime).should be_true
			end

			it "should shift the times list" do
				@timer.times[0].should eq(@timeList[1])
			end

			it "should cause ready_for_upload to be false again" do
				@timer.ready_for_upload?(@currentTime).should be_false
			end
		end
	end
end
