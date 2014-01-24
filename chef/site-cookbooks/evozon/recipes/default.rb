#
# Cookbook Name:: evozon
# Recipe:: default
#
# Copyright 2014, Evozon Systems
#

%w{ php5-cli unzip htop }.each do |pkg|
    package pkg
end
