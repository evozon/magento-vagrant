#!/bin/bash

hash berks > /dev/null 2>&1 || { gem install berkshelf }

if hash vagrant > /dev/null; then
  vagrant plugin install vagrant-berkshelf
  vagrant plugin install vagrant-omnibus
  vagrant plugin install vagrant-hostmanager
  vagrant plugin install vagrant-vbguest
else
  echo "Vagrant is not installed"
  exit 1
fi
