name            'rb-manager'
maintainer      'Enrique Jimenez'
maintainer_email 'ejimenez@redborder.com'
license          'All rights reserved'
description      'Installs/Configures redborder manager'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.0.11'

depends 'zookeeper'
depends 'kafka'
depends 'druid'
