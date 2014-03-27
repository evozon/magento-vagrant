#
# Cookbook Name:: evozon
# Attribute:: default
#
# Copyright 2014, Evozon Systems
#

case node['platform_family']
when 'debian'
	default['evozon']['base_packages'] = %W{php5-cli htop}
end