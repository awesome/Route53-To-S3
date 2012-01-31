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

Move the ```route53_config.txt``` file to ```.route53```

    $ route53_config.txt .route53

Modify the ```.route53``` file to contain your AWS information.

    $ vim .route53

Now bundle install, and you're done!

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

Authors
-------
Joseph McCullough
