$_hostname = 'puppet'
$_domain = 'puppetize.net'
$_fqdn = "${_hostname}.${_domain}"

# facter 1.6.1 compatibility
$osfamily = 'Debian'

file { '/etc/hostname':
  ensure  => present,
  mode    => '0444',
  owner   => 'root',
  group   => 'root',
  content => "${_fqdn}\n",
  notify  => Exec['change-hostname']
}

exec { 'change-hostname':
  command     => '/bin/sh /etc/init.d/hostname.sh',
  refreshonly => true
}

host { 'squeeze32.vagrantup.com':
  ensure => absent
}

host { $_fqdn:
  ensure       => present,
  ip           => '127.0.1.1',
  host_aliases => [$_hostname]
}

package { 'puppetmaster':
  ensure  => present,
  require => [
    Exec['change-hostname'],
    Host[$_fqdn]
  ]
}

# XXX: avoids an error when running "puppet apply" from "vagrant provision"
#
#  err: Removing mount files: /etc/puppet/files does not exist or is not a
#  directory
#
# This error occurred on Debian 6.0.6 after installing the 'puppetmaster'
# package.
file { '/etc/puppet/files':
  ensure  => directory,
  require => Package['puppetmaster']
}

service { 'puppetmaster':
  ensure    => running,
  hasstatus => true,
  require   => Package['puppetmaster']
}

package { 'apache2':
  ensure => installed
}

file { '/var/www/index.html':
  ensure  => present,
  source  => 'puppet:///modules/site/index.html',
  mode    => '0444',
  owner   => 'root',
  group   => 'root',
  require => Package['apache2'],
  before  => Service['apache2']
}

service { 'apache2':
  ensure  => running,
  require => Package['apache2']
}

include site::puppet::development
