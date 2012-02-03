Route53 Backups
===============

Losing your DNS records is quite possibly the worst thing in the world.
This project backs up DNS records set through AWS's Route53 into
an S3 Bucket

Installation and Configuration
------------------------------

Requirements:

* Ruby 1.9.2 or greater
* bundler

Clone the repo and change to its directory.

    $ git clone git://github.com/joequery/Route53-To-S3.git
    $ cd Route53-To-S3

Modify the ```bin/.route53``` file to contain your AWS information.
The file contains extensive comments so you'll know exactly where 
to put your information.

    $ cd bin
    $ vim .route53

Now bundle install, and you're done configuring!

    $ bundle install

Usage
-----

cd to the ```bin``` directory.

To start the daemon

    $ ruby r53backup.rb start

To stop the daemon

    $ ruby r53backup.rb stop

To restart the daemon
    
    $ ruby r53backup.rb restart

The ```.route53``` configuration file contains a ```times``` option
that allows you to specify times when the daemon will backup from
Route53 and upload to your specified S3 bucket.

Testing
-------

There is a test configuration file located at ```spec/.route53_test```. 
If you wish to run tests, modify this configuration file to have your AWS 
security credentials. Make sure you don't use the same database name and
upload path combination, or you'll overwrite your real data!

Many tests will pass without the aws information, but at least 
provide db location and daemon information.

After editing the test configuration file, you can run the tests via

    $ bundle exec rspec spec/*

Authors
-------
Joseph McCullough
