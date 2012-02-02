# Backup Route53 DNS records to your S3 bucket!

# Get lib files added to path
$:.unshift File.join(File.dirname(__FILE__), "../lib")

require 'bundler/setup'
require 'rubygems'
require 'route53backup'

# Create configuration object from the config file
Configuration.new('spec/.route53_test')

# Connect to S3
Route53Backup.connect

# Grab DNS records and populate a sqlite3 database with them
Route53Backup.populate_db

# Upload the populated db to S3
Route53Backup.upload_db
