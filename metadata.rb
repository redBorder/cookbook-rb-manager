name             'manager'
maintainer      'Enrique Jimenez'
maintainer_email 'ejimenez@redborder.com'
license          'All rights reserved'
description      'Installs/Configures manager'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.0.1'

depends 'kafka', '0.0.1'
depends 'zookeeper', '0.0.1'
