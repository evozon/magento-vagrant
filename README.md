# Magento-Vagrant

Vagrant based LAMP development environment for Magento

## Requirements

The following softwares needs to be installed:

* Vagrant (www.vagrant.com)
* VirtualBox (www.virtualbox.org)
* Berkshelf
* vagrant-berkshelf

## Installed Packages

* build-essential
* apache2
* mysql-server
* php5 (and some modules)
* vim
* htop
* curl
* git

## Default settings

| Service Name     | 			  |
|------------------|-------------:|
| SSH Host         | 33.33.33.10  |
| SSH User         | vagrant      |
| SSH Pass         | vagrant      |
| SSh Port         | 2222         |
| MySQL Host       | 127.0.0.1	  |
| MySQL Port       | 3306 		  |
| MySQL User       | magento 	  |
| MySQL Password   | magento 	  |

## Virtualhost

Default virtualhost is `magento.dev`.
If you are not using `vagrant-hostmanager` plugin please run the command below:

	sudo sh -c "echo 33.33.33.10 magento.dev >> /etc/hosts"

The virtualhost is set on the `magento` directory.

Application entry point:

	http://magento.dev/


## Installation

Getting up and running is as easy as clonning the repo:

	git clone git@github.com:evozon/Magento-Vagrant.git

And running Vagrant

	cd Magento-Vagrant
	vagrant up

# License

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.