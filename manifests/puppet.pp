$_hostname = 'puppet'
$_domain = 'puppetize.net'
$_fqdn = "${_hostname}.${_domain}"

file { '/etc/hostname':
  ensure  => present,
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
  require => Package['apache2'],
  before  => Service['apache2'],
  content => "<h1>Huh?</h1><p><a href=\"https://github.com/puppetize\">https://github.com/puppetize</a></p>"
}

service { 'apache2':
  ensure  => running,
  require => Package['apache2']
}

file { '/home/vagrant/.vimrc':
  ensure  => present,
  mode    => '0444',
  owner   => 'vagrant',
  content => "syntax on\n"
}

include site::vim-puppet
