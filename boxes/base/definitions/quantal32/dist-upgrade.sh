#!/bin/sh

apt-get -y dist-upgrade

VBOX_VERSION=$(cat /home/vagrant/.vbox_version)

# Build virtualbox guest addiotions for non-running kernels installed
# during "apt-get dist-upgrade", above.
dpkg -l | \
awk '$2 ~ /^linux-headers-.*-generic$/ {sub("linux-headers-","",$2); print $2}' | \
while read kernelver; do
        dkms install -k $kernelver -m vboxguest -v $VBOX_VERSION
done
