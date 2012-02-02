# This class populates our database with Route53 data and uploads to S3

require 'configuration'
require 'db'
require 'dns'
require 'aws/s3'

module Route53Backup

	def self.connect(db=nil, zones=nil)
		conn = AWS::S3::Base.establish_connection!(
			:access_key_id     => Configuration.aws['access_key'],
			:secret_access_key => Configuration.aws['secret_key']
		)

		return false unless conn

		# Create a db object
		@db = db || DB.new
	
		# Get zones. Grab them from AWS if not passed in to this method
		@zones = zones
		if @zones.nil? || @zones.empty?
			DNS.connect
			@zones = DNS.zones
		end
		return true
	end

	# We have these parameters as nil so they can be overridden during
	# testing.
	def self.populate_db

		# Create the database at the location specified in the config file
		@db.create

		@zones.each do |zone|
			# Create a table for each zone found
			@db.create_zone_table(zone)

			# Get the records of each zone
			records = DNS.records(zone)

			# For each record, make an entry into its associated zone.
			records.each do |record|
				@db.add_record(record, zone)
			end
		end
	end

end
