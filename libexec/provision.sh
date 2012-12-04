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
source "$shome/libexec/_treadstone"

# entry point
function main {
  ntpdate-debian -u

  export DEBIAN_FRONTEND=noninteractive
  local apt_install="aptitude install -y -q"

  # update packages
  aptitude update
  aptitude safe-upgrade -q -y

  # install avahi for zeroconf (bonjour)
  $apt_install install -y avahi-daemon
  sudo service avahi-daemon restart # might have old name of the basebox

  # useful
  $apt_install htop
  $apt_install vim unzip

  # aptitude cleanup
  aptitude clean
}

# define command line options:
#   var name, default, description, short option

# parse the command-line
parse_command_line "$@" || exit $?
eval set -- "${FLAGS_ARGV}"

# pass arguments to entry point
main "$@"
