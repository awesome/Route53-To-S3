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

		@timeConfig= "00:00, 08:00, 16:00"
		@timer = Timer.new(@timeConfig)
		@timeList = @timer.times.clone
	end

	describe "initialization" do
		it "should create a Timer object" do
			@timer.should_not be_nil
		end

		it "should have an accessible 'times' attribute composed of Time objects" do
			@timer.times.should_not be_nil
			@timer.times[0].class.should eq(Time)
		end
	end

	describe "#shift_time" do
		it "should shift the first time slot to the last" do
			@timer = Timer.new(@timeConfig)
			newTimeList = [@timeList[1], @timeList[2], @timeList[0]]
			@timer.shift_time
			@timer.times.should eq(newTimeList)
		end
	end

	describe "#upcoming_time" do
		it "should return the first time entry as a Time object" do
			upcomingTime = @timer.upcoming_time

			# Make sure we got the first entry
			upcomingTime.to_s.should eq(@timeList[0].to_s)

			# Make sure it's a Time object so we can do operations on it
			upcomingTime.class.should eq(Time)
		end
	end

	describe "#time_difference" do
		it "should display a human readable time difference" do
			t1 = @timeList[0]
			t2 = @timeList[1]
			diff = @timer.time_difference(t1, t2)
			diff.should eq("8 hours and 0 minutes")
		end
	end

	describe "#ready_for_upload?" do
		describe "if current time < upcoming time" do
			it "should return false" do
				# Fake a current time. One less than first entry is
				# still less than first entry, so should work!
				currentTime = @timeList.first - 1
				@timer.ready_for_upload?(currentTime).should be_false
			end
		end

		describe "if current time >= upcoming time" do
			# We want to share the timer object between the
			# two tests
			before(:all) do
				@timer = Timer.new(@timeConfig)

				# Choose first entry!
				@currentTime = @timeList[0]
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
