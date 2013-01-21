OpenStack:

* backup/restore for nova-compute
* backup/restore for quantum
* manage static routes for additional subnet
* LVM snapshots and optional partition/filesystem-based backups
  for cinder volumes
* monitoring (Nagios, etc.)

Bacula:

* list and restore from any applicable jobids
* local volume encryption (mirrored on FTP in encrypted form)

Puppet:

* catalog version = git commit hash
* better source for hiera data than non-versioned .yaml files
