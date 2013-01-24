OpenStack:

* manage static routes for additional subnet
* better backup/restore for nova-compute with respect to running instances
* LVM snapshots and optional partition/filesystem-based backups
  for cinder volumes
* monitoring (Nagios, etc.)

Bacula:

* list and restore from any applicable jobids
* local volume encryption (mirrored on FTP in encrypted form)

Puppet:

* catalog version = git commit hash
* better source for hiera data than non-versioned .yaml files
