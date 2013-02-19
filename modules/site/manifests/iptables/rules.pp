class site::iptables::rules(
  $external_interface,
  $gateway_network
) {
  $iptables_rules = '/usr/local/sbin/iptables-rules'
  $iptables_conf = '/etc/iptables.conf'

  file { $iptables_rules:
    ensure => present,
    source => 'puppet:///modules/site/iptables/iptables-rules',
    mode   => '0555',
    owner  => 'root',
    group  => 'root'
  } ->

  file { $iptables_conf:
    ensure  => present,
    content => template('site/iptables/iptables.conf.erb'),
    mode    => '0444',
    owner   => 'root',
    group   => 'root'
  }
}
