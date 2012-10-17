$_hostname = 'puppet'
$_domain = 'puppetize.net'
$_fqdn = "${_hostname}.${_domain}"

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

include site::vim-puppet
# include site::vim-pathogen
# http://tammersaleh.com/posts/the-modern-vim-config-with-pathogen
# http://jedi.be/blog/2011/12/05/puppet-editing-like-a-pro/

package { 'ruby-dev':
  ensure => installed
}

package { 'cucumber-puppet':
  ensure   => installed,
  provider => gem,
  require  => [
    Package['rubygems'],
    Package['ruby-dev'],
  ]
}

package { 'rspec-puppet':
  ensure   => installed,
  provider => gem,
  require  => [
    Package['rubygems'],
    Package['ruby-dev'],
  ]
}

package { 'puppet-lint':
  ensure   => installed,
  provider => gem,
  require  => [
    Package['rubygems'],
    Package['ruby-dev'],
  ]
}

package { 'git':
  ensure => installed
}

include site::rubygems
