# This class populates our database with Route53 data and uploads to S3

$:.unshift File.dirname(__FILE__)
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

		# If we made it all the way here, assume everything was successful
		# and return true for testing purposes.
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
				puts record
				@db.add_record(record, zone)
			end
		end
	end

	# Upload the db to s3!
	def self.upload_db
		# Get the full path of the database
		dbLoc = Configuration.db['location']
		basename = File.basename(dbLoc)
		upload_path = Configuration.s3['upload_path']
		bucket = Configuration.s3['bucket']
		fullPath = File.join(upload_path, basename)
		AWS::S3::S3Object.store(
			fullPath,
			open(dbLoc),
			bucket
		)
	end

end

Configuration.new('./spec/.route53_test')
Route53Backup.connect
Route53Backup.populate_db
Route53Backup.upload_db
