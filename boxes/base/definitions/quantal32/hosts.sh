#!/bin/sh

# "facter fqdn" won't work unless this is done.
sed -i -E -e 's/^(127.0.1.1\s+)([^\s.]+)$/\1\2.vagrantup.com \2/' /etc/hosts
