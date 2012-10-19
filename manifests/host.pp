include site::rubygems

# FIXME: So wrong, but makes "vagrant up" work on a plain Debian system
# in a virtual machine and "puppet apply" on a physical box at Hetzner.
#
# To make things more complicated, the 'virtual' fact is broken in my
# squeeze base box:
#
#  vagrant@squeeze32:~$ facter virtual
#  physical
#  vagrant@squeeze32:~$ facter --version
#  1.5.7
if $virtual != 'physical' or "${physicalprocessorcount}" == '0' {
  $virtualbox_ose = true
} else {
  $virtualbox_ose = false
}

class { 'site::virtualbox::debian':
  ose => $virtualbox_ose
}

include site::virtualbox
include site::vagrant

group { 'vagrant':
  ensure => present
}

$vagrant_home = '/home/vagrant'

user { 'vagrant':
  ensure => present,
  gid    => 'vagrant',
  home   => $vagrant_home
}

file { $vagrant_home:
  ensure   => directory,
  mode     => '0750',
  owner    => 'vagrant',
  group    => 'vagrant',
  require => User['vagrant']
}

$vagrant_infrastructure_url = 'https://github.com/puppetize/infrastructure'

$git = '/usr/bin/git'

package { 'git':
  ensure => present
}

exec { 'git-clone-vagrant-infrastructure':
  command => "${git} clone --recursive ${vagrant_infrastructure_url} ${vagrant_home}/infrastructure",
  creates => "${vagrant_home}/infrastructure",
  user    => 'vagrant',
  group   => 'vagrant',
  require => [
    File[$vagrant_home],
    Package['git']
  ]
}

cron { 'git-pull-vagrant-infrastructure':
  command => "cd ${vagrant_home}/infrastructure && git fetch && git reset origin/master && git clean -ffd && git reset --hard >/dev/null && git submodule update --init",
  minute  => '*/30',
  user    => 'vagrant'
}

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
  command     => "/bin/sh -c '/sbin/iptables-restore < ${iptables_conf}'",
  refreshonly => true
}

file { '/etc/network/if-up.d/iptables':
  ensure  => present,
  mode    => '0555',
  owner   => 'root',
  group   => 'root',
  content => "#!/bin/sh\niptables-restore < ${iptables_conf}\n"
}

file { '/etc/rc.local':
  ensure => present,
  source => 'puppet:///modules/site/rc.local',
  mode   => '0555',
  owner  => 'root',
  group  => 'root'
}

package { 'sudo':
  ensure => installed
}

site::admin_user { 'uwe':
  ensure   => present,
  fullname => 'Uwe Stuehler',
  email    => 'uwe@bsdx.de',
  rsakey   => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCz0aG1szSSeNCBkz7AiZRgU4Dl63i+C7oBnq3s84mWvhkqJHYH6GsAH2FxCMSr1ETPLIot7YuOWmal+u2Fd25CfQh9AqIjxQAKQBWCJfQTsfnVQHGFJsbHFfn7fjZtDFKEAyjszP5bw/DP8mJhaJ252dvm0xiHB5UrxJ02WK+zrRiqSPrVphu4FPyyyHGFWbEkSD4p4mmmmMjjOTtqON5zu2jXrXD3UqTxZhJh+JcLD8ImYzpogzEaQy6GqM0MnMRtBS0g+eRXRIrW4T1g26ILhWkzCIfdIDnXPnBWQ79Y3Nu8STNxY8xPBPL05o3CFAaeg7+QLB6lNQcR2E2HFOYd'
}

include site::vim-puppet

## development: stuff I installed to preview README.md

package { 'rake':
  ensure => installed
}

package { 'ruby-dev':
  ensure => installed
}

# Version 2.2.1 of this gem did not compile with Ruby 1.8:
# https://github.com/vmg/redcarpet/commit/4f41aea8d523301a1d20b05f7a21b25f5bb13ea9#comments
package { 'redcarpet':
  provider => gem,
  ensure   => '2.2.0',
  require  => [
    Package['rubygems'],
    Package['ruby-dev']
  ]
}
