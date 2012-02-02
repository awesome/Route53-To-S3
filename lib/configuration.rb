# Configurations for the project. All properties related to
# Amazon Web Services will be handled by this class.
require 'rubygems'
require 'bundler/setup'

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
		# Remove the beginning slash from the upload path if present
		upload_path = @config.params['s3']['upload_path']
		if upload_path[0] == '/'
			upload_path = upload_path[1..-1]
		end
		@config.params['s3']['upload_path'] = upload_path
		@config.params['s3']
	end

	def self.db
		@config.params['db']
	end

end
