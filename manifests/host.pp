package { 'rubygems':
  ensure => installed
}

file { '/etc/profile.d/gem.sh':
  ensure  => present,
  source  => 'puppet:///modules/site/gem.sh',
  require => Package['rubygems']
}

include site::vagrant
include site::virtualbox

$iptables_conf = '/etc/iptables.conf'

# Use "iptables-save > /etc/iptables.conf" to update the configuration.
file { $iptables_conf:
  ensure => present,
  mode   => '0444',
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
  content => "#!/bin/sh\niptables-restore < ${iptables_conf}\n"
}

file { '/etc/rc.local':
  ensure => present,
  source => 'puppet:///modules/site/rc.local'
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
  require  => Package['ruby-dev']
}
