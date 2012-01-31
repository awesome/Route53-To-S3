# Configurations for the project. All properties related to
# Amazon Web Services will be handled by this class.
require 'parseconfig'

class Configuration

	# configFile: Location of the configuration file containing the
	#							information you wish to load
	
	def initialize(configFile)
		@config = ParseConfig.new(configFile)		
	end

	def aws
		@config.params['aws']
	end

	def s3
		@config.params['s3']
	end

end
