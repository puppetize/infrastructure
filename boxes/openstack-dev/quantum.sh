#!/bin/sh

set -ex

vlan=1000

quantum net-create public --provider:network_type vlan --provider:segmentation_id $vlan --shared --router:external True
quantum subnet-create public 192.168.0.0/24 --dns_nameservers list=true 10.0.2.3

ip link add link br-virtual name br-virtual.$vlan type vlan id $vlan
ip addr add 192.168.0.1/24 dev br-virtual.$vlan

ip link set br-virtual up
ip link set br-virtual.$vlan up
