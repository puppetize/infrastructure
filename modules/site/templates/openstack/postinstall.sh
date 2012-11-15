#!/bin/sh

# FIXME: replace fixed IP
export OS_AUTH_URL=http://10.0.2.15:5000/v2.0

export OS_TENANT_NAME=admin
export OS_USERNAME=admin
export OS_PASSWORD=<%= admin_password %>

export OS_NO_CACHE=1

vlan=1000
subnet_cidr=192.168.0.0/24
bridge_addr=192.168.0.1/24
nameserver=10.0.2.3

cirros_image=cirros-0.3.0-x86_64-disk
cirros_image_url=https://launchpad.net/cirros/trunk/0.3.0/+download/${cirros_image}.img
instance_name=inst1

set -e

if ! quantum net-show public >/dev/null 2>&1; then
  quantum net-create public --provider:network_type vlan --provider:segmentation_id $vlan --shared --router:external True
fi

if ! quantum subnet-show public >/dev/null 2>&1; then
  quantum subnet-create --name public public $subnet_cidr --dns_nameservers list=true $nameserver
fi

if ! ip link show br-virtual.$vlan >/dev/null 2>&1; then
  ip link add link br-virtual name br-virtual.$vlan type vlan id $vlan
  ip addr add $bridge_addr dev br-virtual.$vlan
fi

ip link set br-virtual up
ip link set br-virtual.$vlan up

if ! glance image-list | awk '$4 == "'"$cirros_image"'"' | grep -q .; then
  glance add name="$cirros_image" is_public=true container_format=bare disk_format=qcow2 copy_from="$cirros_image_url"
  while glance image-list | awk '$4 == "'"$cirros_image"'" && $(12) == "saving"' | grep -q .; do
    sleep 1
  done
  while ! glance image-list | awk '$4 == "'"$cirros_image"'" && $(12) == "active"' | grep -q .; do
    sleep 1
  done
fi

if ! nova show $instance_name >/dev/null 2>&1; then
  nova boot --flavor m1.tiny --image $cirros_image --poll $instance_name
fi

export HOME=/root
if mysql -e 'show create database `nova`' | grep -q utf8; then
  mysql -e 'alter database `nova` CHARACTER SET latin1'
fi
