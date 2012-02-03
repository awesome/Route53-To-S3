require 'configuration'
require 'chronic'

# Manage the uploading interval
class Timer
	attr_reader :times

	# Pass in a string of comma delimited times in the format hh:mm,hh:mm.
	# These are the times the uploads will happen.
	def initialize(times)
		@times = times.split(',').map{|time| Chronic::parse(time.strip)}.sort
	end

	# Pop and append first time to last
	def shift_time
		# Expired time is done for the day. Reset for tomorrow!
		expired = @times.shift
		@times.push(Chronic::parse(expired.strftime("%H:%M")))
	end

	# Return the upcoming time as a Time object to be used in comparison.
	def upcoming_time
		@times.first
	end

	# Return a formatted string of how long until the next upload
	def next_upload
		time_difference(Time.now, upcoming_time)
	end

	# Determine if we've past the time to allow us to upload.
	# We (somewhat counter-intuitively) make currentTime an optional
	# parameter for the sake of testing
	def ready_for_upload?(currentTime=nil)
		currentTime ||= Time.now

		# If the current time has passed the time at the first
		# slot of the @times list, shift and append first time 
		# and return true
		if currentTime >= upcoming_time
			shift_time
			return true
		else
			return false
		end
	end

	# Nicely ouput the difference between two times.
	# t1 and t2 should be time objects
	# Credit (because I was lazy >_>...) http://bit.ly/d1wPb
	def time_difference(t1, t2)
    secs  = (t2-t1).to_i.abs
    mins  = secs / 60
    hours = mins / 60
    days  = hours / 24

    if days > 0
      "#{days} days and #{hours % 24} hours"
    elsif hours > 0
      "#{hours} hours and #{mins % 60} minutes"
    elsif mins > 0
      "#{mins} minutes and #{secs % 60} seconds"
    elsif secs >= 0
      "#{secs} seconds"
    end
	end
end
