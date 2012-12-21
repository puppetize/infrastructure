include site::openstack::all
include site::admin_users

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

# Bacula/FTP setup for Hetzner's root server

$bacula_storage_mountpoint = '/mnt/bacula'

$ftp_host = hiera('ftp_host')
$ftp_user = hiera('ftp_user')
$ftp_password = hiera('ftp_password')
$ftp_directory = hiera('ftp_directory', '/')

$director_password = hiera('bacula_director_password')
$console_password = hiera('bacula_console_password')

$bacula_user = 'bacula'
$bacula_group = 'bacula'
$bacula_storage_dir = '/mnt/bacula/default'

file { '/etc/bacula/scripts/ftp-mirror':
  ensure  => present,
  content => template('site/bacula/ftp-mirror.sh.erb'),
  mode    => '0750',
  owner   => $bacula_user,
  group   => $bacula_group,
  require => Class['bacula::common'],
  before  => Service['bacula-sd']
}

class { 'bacula':
  is_director       => true,
  is_storage        => true,
  is_client         => true,
  manage_console    => true,
  storage_server    => $::fqdn,
  storage_template  => 'site/bacula/bacula-sd.conf.erb',
  director_server   => $::fqdn,
  director_password => $director_password,
  console_password  => $console_password
}

#bacula::config::client { $::fqdn:
#  director_name => $::hostname
#}
