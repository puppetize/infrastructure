Provisioning:

* lots of disk space in /var/lib/nova for compute node (instances)
* 500G (same as FTP backup space) volume for Bacula storage (/mnt/bacula)

OpenStack:

* better iptables host rule management (NAT from tenant routers and host
  service access)
* SSL security (horizon, VNC, and then all the rest)
* public IPv6 address space
* create nova dns domains and set domain/hostname via DHCP/metadata
* better backup/restore for nova-compute with respect to running instances
  (suspend instances temporarily during backup)
* LVM snapshots and optional partition/filesystem-based backups
  for cinder volumes
* monitoring (Nagios, etc.)

Bacula:

* fix group ownership in restore jobs (home dirs)
* if possible, implement FTP mirroring as an automatic tape changer, where
  volumes are uploaded and downloaded only as needed
* list and restore from any applicable jobids
* local volume encryption (mirrored on FTP in encrypted form)
* speed up Bacula restores from FTP mirror by first downloading only the
  volumes containing catalog backups (or even just the most recently written
  catalog backup volume)

Puppet:

* /var/lib/gems/1.9.1/gems/puppet-3.0.2/lib/puppet/provider/service/upstart.rb:67: warning: class variable access from toplevel
* catalog version = git commit hash
* better source for hiera data than non-versioned .yaml files
