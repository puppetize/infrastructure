class site::iptables::binat
{
  file { '/usr/local/sbin/iptables-binat':
    ensure => present,
    source => 'puppet:///modules/site/iptables-binat',
    mode   => '0555',
    owner  => 'root',
    group  => 'root'
  } ->
  file { '/etc/init.d/iptables-binat':
    ensure => present,
    source => 'puppet:///modules/site/iptables-binat.init',
    mode   => '0555',
    owner  => 'root',
    group  => 'root'
  } ->
  service { 'iptables-binat':
    ensure => running,
    enable => true
  }
}
