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
include_recipe "database::mysql"

%w{ php5-mcrypt }.each do |pkg|
    package pkg
end

remote_file "#{Chef::Config[:file_cache_path]}/magento-#{node['magento']['version']}.tar.gz" do
    checksum node['magento']['checksum']
    source node['magento']['source']
    mode "0644"
end

execute "extract_magento" do
    cwd node['magento']['dir']
    command "tar --strip-components 1 -zxf #{Chef::Config[:file_cache_path]}/magento-#{node['magento']['version']}.tar.gz"

    not_if { File.exists?("#{node['magento']['dir']}/app/etc/local.xml") }
end

execute "mysql-install-magento-privileges" do
    command "/usr/bin/mysql -u root -p#{node[:mysql][:server_root_password]} < /etc/mysql/magento-grants.sql"
    action :nothing
    not_if {File.exists?("#{node['magento']['dir']}/app/etc/local.xml")}
end

web_app "100-magento" do
    server_name node['fqdn']
    server_aliases [node['fqdn'], node['hostname']]
    docroot node['magento']['dir']
    notifies :restast, "service[apache2]", :immediately
end

# mysql connection info
mysql_connection_info = {
    :host       => "localhost", 
    :username   => 'root', 
    :password   => node['mysql']['server_root_password']
}

# create database
mysql_database node['magento']['db']['database'] do
    connection ({:host => "localhost", :username => 'root', :password => node['mysql']['server_root_password']})
    action :create
end

# create magento user
mysql_database_user node['magento']['db']['user'] do
    connection mysql_connection_info
    password node['magento']['db']['password']
    action :create
end

# grant all privileges to magento database
mysql_database_user node['magento']['db']['user'] do
    connection mysql_connection_info
    password node['magento']['db']['password']
    database_name node['magento']['db']['database']
    privileges [:all]
    action :grant
end

# install magento
url = URI::HTTP.build({ :host => node['hostname'], :port => Integer(node['magento']['apache']['unsecure_port']), :path => "/"})
secure_url = URI::HTTPS.build({ :host => node['hostname'], :port => Integer(node['magento']['apache']['secure_port']), :path => "/"})

execute "magento-install" do
    args = [
        "--license_agreement_accepted yes",
        "--locale #{node['magento']['app']['locale']}",
        "--timezone #{node['magento']['app']['timezone']}",
        "--default_currency #{node['magento']['app']['currency']}",
        "--db_host #{node['magento']['db']['host']}",
        "--db_model #{node['magento']['db']['model']}",
        "--db_name #{node['magento']['db']['database']}",
        "--db_user #{node['magento']['db']['user']}",
        "--db_pass #{node['magento']['db']['password']}",
        "--url #{url}",
        "--admin_lastname #{node['magento']['app']['admin_lastname']}",
        "--admin_firstname #{node['magento']['app']['admin_firstname']}",
        "--admin_email #{node['magento']['app']['admin_email']}",
        "--admin_username #{node['magento']['app']['admin_username']}",
        "--admin_password #{node['magento']['app']['admin_password']}",
        "--use_rewrites #{node['magento']['app']['use_rewrites']}",
        "--use_secure #{node['magento']['app']['use_secure']}",
        "--secure_base_url #{secure_url}",
        "--use_secure_admin #{node['magento']['app']['use_secure_admin']}"
    ]

    args << "--db_prefix #{node['magento']['db']['prefix']}" unless node['magento']['db']['prefix'].empty?
  
    cwd node['magento']['dir']
    command "php -f install.php -- #{args.join(' ')}"

    not_if { File.exists?("#{node['magento']['dir']}/app/etc/local.xml") }
end
