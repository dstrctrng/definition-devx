#!/bin/bash -e

#!/bin/bash

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

# load a jason bourne library
source "$shome/bin/_treadstone"

  # entry point
  function main {
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
}

# define command line options:
#   var name, default, description, short option

# parse the command-line
parse_command_line "$@" || exit $?
eval set -- "${FLAGS_ARGV}"

# pass arguments to entry point
main "$@"
