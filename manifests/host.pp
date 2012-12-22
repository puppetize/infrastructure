include site::admin_users
include site::bacula
include site::openstack::all

$iptables_conf = '/etc/iptables.conf'

# Use "iptables-save > /etc/iptables.conf" to update the configuration.
file { $iptables_conf:
  ensure => present,
  mode   => '0444',
  owner  => 'root',
  group  => 'root',
  source => 'puppet:///modules/site/iptables.conf',
  notify => Exec['iptables-restore']
}

exec { 'iptables-restore':
  command     => "/bin/sh -c '/sbin/iptables-restore -n < ${iptables_conf}'",
  refreshonly => true
}

file { '/etc/network/if-up.d/iptables':
  ensure  => present,
  mode    => '0555',
  owner   => 'root',
  group   => 'root',
  content => "#!/bin/sh\niptables-restore < ${iptables_conf}\n"
}
