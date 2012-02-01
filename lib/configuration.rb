# Configurations for the project. All properties related to
# Amazon Web Services will be handled by this class.
require 'parseconfig'

module Configuration

	# configFile: Location of the configuration file containing the
	#							information you wish to load
	
	def self.new(configFile)
		@config = ParseConfig.new(configFile)		
	end

	def self.aws
		@config.params['aws']
	end

	def self.s3
		@config.params['s3']
	end

	def self.db
		@config.params['db']
	end

end
