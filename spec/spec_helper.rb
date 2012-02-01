require 'rubygems'
require 'ostruct'
require 'spork'
require 'rspec'

Spork.prefork do
  RSpec.configure do |config|
    config.mock_with :rspec
    config.color_enabled = true

		#######################################
		# Global test variables
		#######################################
		def sample_zone
			OpenStruct.new({
				:name => "somedomain.com",
				:host_url => "/hostedzone/LOL123"
			})
		end

		def sample_record
			OpenStruct.new({
				:name => "www.somedomain.com",
				:type => "CNAME",
				:ttl => 900,
				:values => ["ns-1741.awsdns-25.co.uk.", 
										"ns-331.awsdns-41.com."] 
			})
		end
		
		#######################################
		# Global test methods
		#######################################
		def find_zone_entry(db, zone)
			db.db.execute <<-SQL
				SELECT * from zones
				WHERE domain='#{zone.name}' AND
				zone_id='#{db.zone_id(zone)}'
			SQL
		end

		def zone_table_created(db, zone)
			tableExists=true
			begin
				db.db.execute <<-SQL
					select * from #{db.clean_zone_name(zone)}
				SQL
			rescue SQLite3::SQLException => e
				if e.message =~ /no such table/i
					tableExists=false
				end
			end
			return tableExists
		end

		def find_record_entry(db, zone, record)
			# Check to see the record was added
			results = db.db.execute <<-SQL
				select * from #{db.clean_zone_name(zone)}
				where 
					name='#{record.name}' AND
					type='#{record.type}' AND
					ttl=#{record.ttl} AND
					vals='#{db.join_values(record)}'
			SQL
		end
  end
end

