name             'magento-ce'
maintainer       'Botond Dani'
maintainer_email 'botond.dani@evozon.com'
license          'Apache 2.0'
description      'Installs/Configures Magento Community Edition'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'
supports		 'ubuntu'

depends 'apache2'
depends 'mysql'
depends 'database'
depends 'elasticsearch', '0.3.7'

provides "default"
provides "elasticsearch"
provides "install"