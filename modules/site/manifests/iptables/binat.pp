# Manage binat (SNAT/DNAT) rules.
class site::iptables::binat
{
  $iptables_binat = '/usr/local/sbin/iptables-binat'
  $binat_conf_yaml = '/etc/binat.conf.yaml'

  file { $binat_conf_yaml:
    mode  => '0444',
    owner => 'root',
    group => 'root'
  } ->

  file { $iptables_binat:
    ensure => present,
    source => 'puppet:///modules/site/iptables/iptables-binat',
    mode   => '0555',
    owner  => 'root',
    group  => 'root'
  }
}
