name             'magento-ce'
maintainer       'Botond Dani'
maintainer_email 'botond.dani@evozon.com'
license          IO,read(File.join(File.dirname(__FILE__), 'LICENSE'))
description      'Installs/Configures Magento Community Edition'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'
supports		 'ubuntu'

depends 'apache2'
depends 'mysql'
depends 'database'