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

  # install avahi for zeroconf (bonjour)
  aptitude install -y avahi-daemon

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
