# frozen_string_literal: true

name             'rb-manager'
maintainer       'Eneo Tecnología S.L.'
maintainer_email 'git@redborder.com'
license          'AGPL-3.0'
description      'Installs/Configures redborder manager'
version          '4.10.0'

depends 'rb-common'
depends 'chef-server'
depends 'zookeeper'
depends 'kafka'
depends 'druid'
depends 'http2k'
depends 'memcached'
depends 'consul'
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
depends 'rb-selinux'
depends 'rbaioutliers'
depends 'rbcgroup'
depends 'rblogstatter'
depends 'rb-arubacentral'
depends 'rb-postfix'
depends 'rb-clamav'
depends 'rb-chrony'
depends 'keepalived'
depends 'mem2incident'
depends 'rb-llm'
depends 'rb-firewall'
depends 'secor'
