require 'configuration'
require 'chronic'

# Manage the uploading interval
class Timer
	attr_reader :times

	# Pass in a list of time strings in the format of 'hh:mm'. These represent the 
	# times in the day the user wants the upload to happen
	def initialize(times)
		@timeList = times
		
		# We won't touch @timeList, so @times will be the 'moving copy' of 
		# times.
		@times = @timeList.clone
	end

	# Pop and append first time to last
	def shift_time
		@times.push(@times.shift)
	end

	# Return the upcoming time as a Time object to be used in comparison.
	def upcoming_time
		Chronic::parse(@times.first)
	end

	# Determine if we've past the time to allow us to upload.
	# We (somewhat counter-intuitively) make currentTime an optional
	# parameter for the sake of testing
	def ready_for_upload?(currentTime=nil)
		currentTime ||= Time.now

		# If the current time has passed the time at the first
		# slot of the @times list, shift and append first time 
		# and return true
		if currentTime > upcoming_time
			shift_time
			return true
		else
			return false
		end
	end
end
