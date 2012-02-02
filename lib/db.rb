# Database interactions are handled here. This class
# needs to be instantiated.

require 'sqlite3'
require 'configuration'

class DB
	attr_reader :db

	def initialize(configFile=nil)

		# If Configuration isn't set yet,  and a config file was
		# specified, we set it.
		if Configuration.db.nil? && !configFile.nil?
			Configuration.new(configFile)
		end

		# Get the database profile and db object
		@config = Configuration.db
	end

	# Create the database with the proper schema.
	def create
		@db = SQLite3::Database.new(@config['location'])
		@db.execute <<-SQL
			create table zones (
				id INTEGER PRIMARY KEY,
				domain TEXT,
				zone_id TEXT,
				comment TEXT
			);
		SQL
	end

	##################################################################
	# Methods for Zones
	##################################################################
	# Extract the zone_id from a zone object's host_url property
	def zone_id(zone)
		# Example host_url: /hostedzone/zoneID
		return zone.host_url.split('/')[2]
	end

	# Create an entry into the zones table. 
	def add_zone(zone)

		# The domain is the name property
		domain = "'#{zone.name}'"

		# Get the urlhost from the zone
		zone_id = "'#{zone_id(zone)}'"

		@db.execute <<-SQL
			insert into zones (domain, zone_id)
			values (#{domain},#{zone_id})
		SQL
	end

	# Alter the zone name string so that it can be used as a table name
	def clean_zone_name(zone)
		zone.name.downcase.gsub(/[^a-z0-9]/, '_')
	end

	# Create a table for a zone that we will store records in
	def create_zone_table(zone)

		@db.execute <<-SQL
			create table #{clean_zone_name(zone)} (
				id INTEGER PRIMARY KEY,
				name TEXT,
				type TEXT,
				ttl TEXT,
				vals TEXT
			);
		SQL
	end
	
	##################################################################
	# Methods for Records
	##################################################################
	# Join the values of the record entry to a string
	def join_values(record)
		record.values.join(',')
	end
	
	# Insert  a record into a zone table
	def add_record(record, zone)
		# Account for the possibility of no ttl	
		ttl = record.ttl.nil?? "''" : record.ttl

		query = <<-SQL
			INSERT into #{clean_zone_name(zone)}
			(name, type, ttl, vals)
			VALUES(
			'#{record.name}',
			'#{record.type}',
			#{ttl},
			'#{join_values(record)}'
			)
		SQL
		@db.execute query
	end
end
