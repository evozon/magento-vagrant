# General Settings
default['magento']['version'] = "1.8.1.0"
default['magento']['source'] = "http://www.magentocommerce.com/downloads/assets/#{node['magento']['version']}/magento-#{node['magento']['version']}.tar.gz"
default['magento']['dir'] = "/var/www/magento"

default['magento']['db']['database'] = "magento"
default['magento']['db']['user'] = "magento"
default['magento']['db']['host'] = "localhost"
default['magento']['db']['model'] = "mysql4"
default['magento']['db']['prefix'] = ""

::Chef::Node.send(:include, Opscode::OpenSSL::Password)

default['magento']['db']['password'] = secure_password
default['magento']['keys']['enckey'] = secure_password

default['magento']['app']['locale'] = "en_US"
default['magento']['app']['timezone'] = "Europe/London"
default['magento']['app']['currency'] = "USD"
default['magento']['app']['backend_servers'] = Array.new
default['magento']['app']['url'] = ""

default['magento']['app']['admin_firstname'] = "Admin"
default['magento']['app']['admin_lastname'] = "User"
default['magento']['app']['admin_email'] = "mage@example.com"
default['magento']['app']['admin_password'] = "admin123456"
default['magento']['app']['admin_frontname'] = "admin"

default['magento']['app']['session_save'] = ""
default['magento']['app']['skip_url_validation'] = "yes"
default['magento']['app']['use_rewrites'] = "yes"
default['magento']['app']['use_secure'] = "no"
default['magento']['app']['secure_base_url'] = "no"
default['magento']['app']['use_secure_admin'] = "no"
default['magento']['app']['enable_charts'] = ""
default['magento']['app']['encryption_key'] = ""

default['magento']['sites'] = Array.new

default['magento']['php']['memory_limit'] = "512M"
default['magento']['php']['max_execution_time'] = "120"
default['magento']['php']['display_errors'] = "Off"
default['magento']['php']['html_errors'] = "Off"
default['magento']['php']['upload_max_filesize'] = "50M"

default['magento']['apache']['unsecure_port'] = 80
default['magento']['apache']['secure_port'] = 443