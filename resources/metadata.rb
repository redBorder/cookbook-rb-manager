name            'rb-manager'
maintainer      'Miguel Negrón'
maintainer_email 'manegron@redborder.com'
license          'All rights reserved'
description      'Installs/Configures redborder manager'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.6.6'

depends 'chef-server'
depends 'zookeeper'
depends 'kafka'
depends 'druid'
depends 'http2k'
depends 'memcached'
depends 'consul'
depends 'hadoop'
depends 'samza'
depends 'nginx'
depends 'geoip'
depends 'snmp'
depends 'rbmonitor'
depends 'rbscanner'
depends 'webui'
depends 'f2k'
depends 'pmacct'
depends 'logstash'
depends 'postgresql'
depends 'mongodb'
depends 'minio'
depends 'rbdswatcher'
depends 'rbevents-counter'
depends 'rsyslog'
depends 'rbnmsp'
depends 'rbale'
depends 'n2klocd'
depends 'freeradius'
depends 'rbcep'
depends 'cron'
#depends 'ohai'
depends 'rb-selinux'
#depends 'rbaioutliers'
depends 'rbcgroup'
depends 'rblogstatter'
depends 'rb-arubacentral'
