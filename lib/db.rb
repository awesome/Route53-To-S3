# Database interactions are handled here. This class
# needs to be instantiated.

require 'sqlite3'
require 'configuration'

class DB

	def initialize(configFile=nil)

		# If Configuration isn't set yet,  and a config file was
		# specified, we set it.
		if Configuration.db.nil? && !configFile.nil?
			Configuration.new(configFile)
		end

		# Get the database profile
		@config = Configuration.db

		# Now create a database
		@db = SQLite3::Database.new(@config['location'])
		rows = @db.execute <<-SQL
			create table numbers(
				name varchar(30),
				val int
			);
		SQL
	end

end
