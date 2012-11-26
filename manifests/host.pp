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
include site::vagrant::veewee
include site::vagrant::infrastructure

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

package { 'sudo':
  ensure => installed
}

site::admin_user { 'uwe':
  ensure   => present,
  fullname => 'Uwe Stuehler',
  email    => 'uwe@bsdx.de',
  rsakey   => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCz0aG1szSSeNCBkz7AiZRgU4Dl63i+C7oBnq3s84mWvhkqJHYH6GsAH2FxCMSr1ETPLIot7YuOWmal+u2Fd25CfQh9AqIjxQAKQBWCJfQTsfnVQHGFJsbHFfn7fjZtDFKEAyjszP5bw/DP8mJhaJ252dvm0xiHB5UrxJ02WK+zrRiqSPrVphu4FPyyyHGFWbEkSD4p4mmmmMjjOTtqON5zu2jXrXD3UqTxZhJh+JcLD8ImYzpogzEaQy6GqM0MnMRtBS0g+eRXRIrW4T1g26ILhWkzCIfdIDnXPnBWQ79Y3Nu8STNxY8xPBPL05o3CFAaeg7+QLB6lNQcR2E2HFOYd'
}

ssh_authorized_key { 'uwe@Nexus 7':
  user => 'uwe',
  type => 'ssh-rsa',
  key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCWE0TEhd/MNZ4hOLN6/RXVMqQIgXN8ZIZkSJSnkxyjkR9chQ2T/jBJf0f1PvNPhXvt0SjwEM68pw66XEGvblVgED2BhGboO4n4VpI35L39Ysv+5jQq1Ga4k17MnjFtLJ6L+/o6UYTPL7K7fHGJn2Rjvp/00atdt7Q1MCx9AjCs/64WIrYN9KqaRDksAeHbnb7wpQ1euThzI5XwmYXu+Rz7hmLogUj8AKZdfWk4hO6Sm83/TrALIn2+xJDBUgFBhsx5w2t23tBOEsTwLKlsVR6sEMunYN+kB2D5LmplHhGFl+mSShrYF1yUFzAHVG7wBhMGAv5Hl/7pEzZDt771CKvh'
}

#include site::puppet::development

## development: stuff I installed to preview README.md

# Version 2.2.1 of this gem did not compile with Ruby 1.8:
# https://github.com/vmg/redcarpet/commit/4f41aea8d523301a1d20b05f7a21b25f5bb13ea9#comments
#package { 'redcarpet':
#  provider => gem,
#  ensure   => '2.2.0',
#  require  => [
#    Package['rubygems'],
#    Package['ruby-dev']
#  ]
#}
