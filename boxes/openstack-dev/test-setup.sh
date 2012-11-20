#! /bin/sh

set -e

. /etc/openrc.sh

vlan=1000
bridge_addr=192.168.0.1/24

cirros_image=cirros-0.3.0-x86_64-disk
#cirros_image_url=https://launchpad.net/cirros/trunk/0.3.0/+download/${cirros_image}.img
instance_name=inst1

if ! ip link show br-virtual.$vlan >/dev/null 2>&1; then
  ip link add link br-virtual name br-virtual.$vlan type vlan id $vlan
  ip addr add $bridge_addr dev br-virtual.$vlan
fi

ip link set br-virtual up
ip link set br-virtual.$vlan up

#if ! glance image-list | awk '$4 == "'"$cirros_image"'"' | grep -q .; then
#  glance add name="$cirros_image" is_public=true container_format=bare disk_format=qcow2 copy_from="$cirros_image_url"
#  while glance image-list | awk '$4 == "'"$cirros_image"'" && $(12) == "saving"' | grep -q .; do
#    sleep 1
#  done
#  while ! glance image-list | awk '$4 == "'"$cirros_image"'" && $(12) == "active"' | grep -q .; do
#    sleep 1
#  done
#fi

if ! nova show $instance_name >/dev/null 2>&1; then
  nova boot --flavor m1.tiny --image $cirros_image --poll $instance_name
elif ! pgrep qemu-system >/dev/null; then
  echo -n "Restarting $instance_name..."
  nova stop $instance_name
  while ! nova show $instance_name | grep -q SHUTOFF; do sleep 1; done
  nova start $instance_name
  echo done
fi

exit 0
