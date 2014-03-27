#
# Cookbook Name:: magento-ce
# Recipe:: default
#
# Copyright (C) 2014 Evozon Systems
# 
# All rights reserved - Do Not Redistribute
#

require 'uri'

include_recipe "apache2"
include_recipe "apache2::mod_rewrite"
include_recipe "apache2::mod_deflate"
include_recipe "apache2::mod_headers"

%w{ php5-mcrypt }.each do |name|
    package name do
        action :install
    end
end

include_recipe "magento-ce::install"

node['magento']['modules'].each do |name, v|
	if node['magento']['modules'][name]['enabled']
		Chef::Log.info("Enabling magento module '#{name}'")
		include_recipe "#{name}"
	end
end