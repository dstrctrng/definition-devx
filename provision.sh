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

  # setup ssh keys
  mkdir -p /root/.ssh
  chmod 750 /root/.ssh
  (cat $shome/config/vagrant_keys $shome/.tmp/authorized_keys 2>&- || true) > /root/.ssh/authorized_keys || true

  # create same username as host user
  local nm_host_user="$(cat $shome/.tmp/whoami 2>&- || true)"
  if [[ -n "$nm_host_user" ]]; then
    groupadd $nm_host_user || true
    useradd -g $nm_host_user -s /bin/bash -m $nm_host_user || true

    local nm_user
    for nm_user in $nm_host_user; do
      mkdir -p /home/${nm_user}/.ssh
      chmod 750 /home/${nm_user}/.ssh
      rsync -ia /root/.ssh/authorized_keys /home/${nm_user}/.ssh/
      chown -R ${nm_user}:${nm_user} /home/${nm_user}/.ssh/
    done
  fi

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
