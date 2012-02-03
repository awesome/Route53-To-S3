Route53 Backups
===============

Losing your DNS records is quite possibly the worst thing in the world.
This project backs up DNS records set through AWS's Route53 into
an S3 Bucket

Installation and Configuration
------------------------------

Clone the repo and change to its directory!

    $ git clone git://github.com/joequery/Route53-To-S3.git
    $ cd Route53-To-S3

Modify the ```bin/.route53``` file to contain your AWS information.

    $ cd bin
    $ vim .route53

Now bundle install, and you're done configuring!

    $ bundle install

Usage
-----

To backup your DNS records once, cd to the ```bin``` directory and 
run

    $ ruby route53backup.rb

To have the DNS backup running as a daemon, cd to the ```bin``` directory
and run

    $ ruby route53backup.rb --daemon 

The ```.route53``` configuration file contains a ```upload-interval``` option
that allows you to specify an upload interval in seconds when the process is
running as a daemon.

Testing
-------

There is a test configuration file located at ```spec/.route53_test```. 
If you wish to run tests, modify this configuration file to have your AWS 
security credentials. Make sure you don't use the same database name and
upload path combination, or you'll overwrite your real data!

After editing the test configuration file, you can run the tests via

    $ bundle exec rspec spec/*

Authors
-------
Joseph McCullough
