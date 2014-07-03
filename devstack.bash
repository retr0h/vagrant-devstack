#!/usr/bin/env bash

OPENSTACK_BRANCH=stable/icehouse
OPENSTACK_ADM_PASSWORD=devstack

ROOT="$( cd "$( dirname "${0}" )" && pwd )"
PWD=$(su ${OS_USER} -c "cd && pwd")
DEVSTACK=${PWD}/devstack

export OPENSTACK_BRANCH=${OPENSTACK_BRANCH}
export OPENSTACK_ADM_PASSWORD=${OPENSTACK_ADM_PASSWORD}

export DEBIAN_FRONTEND noninteractive
sudo apt-get update
sudo apt-get install -qqy git

if [ ! -d "${DEVSTACK}" ]; then
	echo "Download devstack into ${DEVSTACK}"
	su ${OS_USER} -c "cd && git clone -b ${OPENSTACK_BRANCH} https://github.com/openstack-dev/devstack.git ${DEVSTACK}"

	# https://bugs.launchpad.net/python-openstackclient/+bug/1326811
	awk '/install_pip.sh/ { print; print "sudo pip install --upgrade setuptools"; next }1' ${DEVSTACK}/stack.sh > ${DEVSTACK}/stack_patched.sh
	chmod +x ${DEVSTACK}/stack_patched.sh

	echo "Copy config from ${ROOT}/conf/local.conf to ${DEVSTACK}/local.conf"
	cp ${ROOT}/conf/local.conf ${DEVSTACK}/local.conf
	chown ${OS_USER}:${OS_USER} ${DEVSTACK}/local.conf
fi

echo "Start Devstack"
su ${OS_USER} -c "cd ${DEVSTACK} && ./stack_patched.sh"
