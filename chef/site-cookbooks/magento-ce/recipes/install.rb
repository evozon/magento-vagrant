#
# Cookbook Name:: magento-ce
# Recipe:: install
#
# Copyright (C) 2014 Evozon Systems
#
# All rights reserved - Do Not Redistribute
#

include_recipe "database::mysql"

remote_file "#{Chef::Config[:file_cache_path]}/magento-#{node['magento']['version']}.tar.gz" do
    checksum node['magento']['checksum']
    source node['magento']['source']
end

execute "extract_magento" do
    cwd node['magento']['dir']
    command "tar --strip-components 1 -zxf #{Chef::Config[:file_cache_path]}/magento-#{node['magento']['version']}.tar.gz"

    not_if { File.exists?("#{node['magento']['dir']}/app/etc/local.xml") }
end

execute "mysql-install-magento-privileges" do
    command "/usr/bin/mysql -u root -p#{node[:mysql][:server_root_password]} < /etc/mysql/magento-grants.sql"
    action :nothing
    not_if { File.exists?("#{node['magento']['dir']}/app/etc/local.xml") }
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
    connection mysql_connection_info
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
url = URI::HTTP.build({ :host => node['fqdn'], :port => Integer(node['magento']['apache']['unsecure_port']), :path => "/"})
secure_url = URI::HTTPS.build({ :host => node['fqdn'], :port => Integer(node['magento']['apache']['secure_port']), :path => "/"})

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
    args << "--session_save #{node['magento']['app']['session_save']}" unless node['magento']['app']['session_save'].empty?
    args << "--admin_frontname #{node['magento']['app']['admin_frontname']}" unless node['magento']['app']['admin_frontname'].empty?
    args << "--skip_url_validation #{node['magento']['app']['skip_url_validation']}" unless node['magento']['app']['skip_url_validation'].empty?
    args << "--use_rewrites #{node['magento']['app']['use_rewrites']}" unless node['magento']['app']['use_rewrites'].empty?
    args << "--use_secure #{node['magento']['app']['use_secure']}" unless node['magento']['app']['use_secure'].empty?
    args << "--secure_base_url #{node['magento']['app']['secure_base_url']}" unless node['magento']['app']['secure_base_url'].empty?
    args << "--use_secure_admin #{node['magento']['app']['use_secure_admin']}" unless node['magento']['app']['use_secure_admin'].empty?
    args << "--enable_charts #{node['magento']['app']['enable_charts']}" unless node['magento']['app']['enable_charts'].empty?
    args << "--encryption_key #{node['magento']['app']['encryption_key']}" unless node['magento']['app']['encryption_key'].empty?

    cwd node['magento']['dir']
    command "php -f install.php -- #{args.join(' ')}"

    not_if { File.exists?("#{node['magento']['dir']}/app/etc/local.xml") }
end
