#!/bin/bash -feux

#/ NAME
#/     provision.sh -- vagrant shell provisioner for zendesk definition
#/
#/ SYNOPSIS
#/     
#/     ./provision.sh
#/

umask 022

# figure out the project root under which bin, lib live
shome="/vagrant"
cd $shome

# entry point
function main {
  export DEBIAN_FRONTEND=noninteractive

  # update packages
  aptitude update
  aptitude safe-upgrade -q -y

  # install ruby
  aptitude install -y ruby rubygems ruby-dev libopenssl-ruby

  gem install rubygems-update
  set +f
  pushd /var/lib/gems/1.8/gems/rubygems-update-* > /dev/null
  set -f
  ruby setup.rb
  popd > /dev/null
  gem install bundler

  # aptitude cleanup
  aptitude clean

  # microwave
  bin/microwave
}

# pass arguments to entry point
main "$@"
