# Handle pulling DNS from Route53
require 'route53'
require 'configuration'

class DNS

	#######################################
	# Create the Route53 connection object
	#######################################
	def self.connect(configFile=nil)

		# If Configuration isn't set yet,  and a config file was
		# specified, we set it.
		if Configuration.aws.nil? && !configFile.nil?
			Configuration.new(configFile)
		end

		# Get the aws profiles
		@aws = Configuration.aws

		# Now create a Route53 connection
		@conn = Route53::Connection.new(@aws['access_key'],@aws['secret_key'])
	end

	#######################################
	# Get the list of DNS zones
	#######################################
	def self.zones
		@conn.get_zones
	end

	############################################
	# Get the list of DNS records for a DNS zone
	############################################
	def self.records(zone)
		records = zone.get_records
	end

end
