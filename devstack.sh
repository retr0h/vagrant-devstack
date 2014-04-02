#!/bin/sh

# environment variables
OPENSTACK_BRANCH=stable/havana
OPENSTACK_ADM_PASSWORD=devstack

# determine own script path
BASHPATH="`dirname \"$0\"`"               # relative
BASHPATH="`( cd \"$BASHPATH\" && pwd )`"  # absolutized and normalized
echo "run script from $BASHPATH"

export OPENSTACK_BRANCH=$OPENSTACK_BRANCH
export OPENSTACK_ADM_PASSWORD=$OPENSTACK_ADM_PASSWORD

# update system
export DEBIAN_FRONTEND noninteractive
sudo apt-get update || sudo yum update -y
sudo apt-get install -qqy git || sudo yum install -y git

# determine checkout folder
PWD=$(su $OS_USER -c "cd && pwd")
DEVSTACK=$PWD/devstack

# check if devstack is already there
if [ ! -d "$DEVSTACK" ]; then
  echo "Download devstack into $DEVSTACK"

  # clone devstack
  su $OS_USER -c "cd && git clone -b $OPENSTACK_BRANCH https://github.com/openstack-dev/devstack.git $DEVSTACK"

  echo "Copy configuration"

  # copy local.conf settings
  echo "copy config from $BASHPATH/conf/local.conf to $DEVSTACK/local.conf"
  cp $BASHPATH/conf/local.conf $DEVSTACK/local.conf
  chown $OS_USER:$OS_USER $DEVSTACK/local.conf
fi

# start devstack
echo "Start Devstack"
su $OS_USER -c "cd $DEVSTACK && ./stack.sh"
