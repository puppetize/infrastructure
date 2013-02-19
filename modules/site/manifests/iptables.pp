# Manage "manual" iptables(8) rules.
class site::iptables(
  $external_interface = hiera('external_interface', 'eth0'),
  $gateway_network    = hiera('gateway_network', '192.168.254.0/24')
) {
  include site::iptables::binat

  class { 'site::iptables::rules':
    external_interface => $external_interface,
    gateway_network    => $gateway_network
  }

  file { '/etc/init.d/iptables':
    ensure => present,
    source => 'puppet:///modules/site/iptables/iptables.init',
    mode   => '0555',
    owner  => 'root',
    group  => 'root'
  } ~>

  service { 'iptables':
    ensure    => running,
    enable    => true,
    subscribe => [
      Class['site::iptables::binat'],
      Class['site::iptables::rules']
    ]
  } ->

  # Load rules automatically when any interface is brought up.
  file { '/etc/network/if-up.d/iptables':
    ensure  => present,
    source  => 'puppet:///modules/site/iptables/iptables.if-up',
    mode    => '0555',
    owner   => 'root',
    group   => 'root'
  }
}
