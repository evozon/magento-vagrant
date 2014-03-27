# -*- mode: ruby -*-
# vi: set ft=ruby :

#-----------------------------------------------------------------------------
# Application Configuration
#-----------------------------------------------------------------------------

app_config = {
    "box"               => "precise64",
    "box_url"           => "http://files.vagrantup.com/precise64.box",
    "guest_ip"          => "33.33.33.34",
    "hostname"          => "magento.local",
    "aliases"           => %w(pma.magento.local),
    "sync_folder"       => "/www/magento",
    "docroot"           => "/www/magento",
    "chef_version"      => "11.8.2",
    "chef_env"          => "dev",
    "chef_log"          => "debug",
    "virtualbox"        => {
      "cpus"                  => "2",
      "memory"                => "2048"
    }
}

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.require_plugin "vagrant-berkshelf"
Vagrant.require_plugin "vagrant-omnibus"
Vagrant.require_plugin "vagrant-hostmanager"
Vagrant.require_plugin "vagrant-vbguest"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  #-----------------------------------------------------------------------------
  # Omnibus Plugin
  #-----------------------------------------------------------------------------
  if Vagrant.has_plugin?("vagrant-omnibus") then
    config.omnibus.chef_version = app_config["chef_version"]
  end


  #-----------------------------------------------------------------------------
  # Berkshelf Plugin
  #-----------------------------------------------------------------------------
  if Vagrant.has_plugin?("vagrant-berkshelf") then
    config.berkshelf.enabled = true
  end


  #-----------------------------------------------------------------------------
  # Hostmanager Plugin
  #-----------------------------------------------------------------------------
  if Vagrant.has_plugin?("vagrant-hostmanager") then
    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
    config.hostmanager.ignore_private_ip = false
    config.hostmanager.include_offline = false
    config.hostmanager.aliases = app_config['aliases']
  end


  #-----------------------------------------------------------------------------
  # Vagrant Box
  #-----------------------------------------------------------------------------
  config.vm.box = app_config["box"]
  config.vm.box_url = app_config["box_url"]
  config.vm.hostname = app_config["hostname"]


  #-----------------------------------------------------------------------------
  # Networking
  #-----------------------------------------------------------------------------
  config.vm.network :private_network, ip: app_config["guest_ip"]


  #-----------------------------------------------------------------------------
  # SSH
  #-----------------------------------------------------------------------------
  config.ssh.forward_agent = true


  #-----------------------------------------------------------------------------
  # Synced Folders
  #-----------------------------------------------------------------------------
  # NFS sync folder
  # config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.synced_folder "./magento", app_config["sync_folder"], type: "nfs"


  #-----------------------------------------------------------------------------
  # VirtualBox Provider
  #-----------------------------------------------------------------------------
  config.vm.provider :virtualbox do |vb|
    vb.gui = false
    app_config["virtualbox"].each do |key, value|
      vb.customize ["modifyvm", :id, "--#{key}", value]
    end
  end


  #-----------------------------------------------------------------------------
  # Chef-Solo Provision
  #-----------------------------------------------------------------------------
  config.vm.provision "chef_solo" do |chef|
    VAGRANT_JSON = JSON.parse(Pathname(__FILE__).dirname.join('chef/nodes', 'vagrant.json').read)

    chef.roles_path = "./chef/roles"
    chef.data_bags_path = "./chef/data_bags"
    chef.environments_path = "./chef/environments"
    chef.environment = app_config['chef_env']
    chef.log_level = app_config['chef_log']
    chef.run_list = VAGRANT_JSON.delete('run_list')
    chef.json = VAGRANT_JSON.merge!({
        "mysql" => {
            "server_root_password" => "freemail",
            "server_repl_password" => "freemail",
            "server_debian_password" => "freemail"
        },
        "magento" => {
            "dir" => app_config["sync_folder"]
        }
    })
  end

  #-----------------------------------------------------------------------------
  # hostmanager Provision
  #-----------------------------------------------------------------------------
  config.vm.provision :hostmanager

end
