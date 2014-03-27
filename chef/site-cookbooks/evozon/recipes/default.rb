#
# Cookbook Name:: evozon
# Recipe:: default
#
# Copyright 2014, Evozon Systems
#

node['evozon']['base_packages'].each do |name|
    package name do
    	action :install
    end
end
