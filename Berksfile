#!/usr/bin/env ruby
#^syntax detection

site :opscode

# default cookbooks for Ubuntu Platform
cookbook 'locale'
cookbook 'apt', '2.3.4'
cookbook 'ohai', '1.1.8'
cookbook 'build-essential', '1.4.2'
cookbook 'openssl', '1.1.0'
cookbook 'ntp', '1.5.4'
cookbook 'vim', '1.1.2'
cookbook 'git', '2.9.0'
cookbook 'xml', '1.2.0'
cookbook 'apache2', '1.8.14'
cookbook 'php', '1.3.10'
cookbook 'mysql', '4.0.20'

# application specific cookbooks
cookbook 'evozon', 
    path: './chef/site-cookbooks/evozon'
cookbook 'magento-ce',
    path: './chef/site-cookbooks/magento-ce'