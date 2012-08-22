#!/bin/bash -e

umask 022

cd /vagrant

export DEBIAN_FRONTEND=noninteractive

# update packages
aptitude update
aptitude safe-upgrade -q -y

# install ruby
aptitude install -y ruby rubygems ruby-dev libopenssl-ruby

gem install rubygems-update
cd /var/lib/gems/1.8/gems/rubygems-update-*
ruby setup.rb
gem install bundler

# aptitude cleanup
aptitude clean

# microwave
bin/microwave
