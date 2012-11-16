# Perform additional OpenStack setup outside of Puppet.
class site::openstack::setup
{
  file { '/etc/init.d/openstack-setup':
    ensure  => present,
    content => template('site/openstack/openstack-setup.init'),
    owner   => 'root',
    group   => 'root',
    mode    => '0555',
  } ->
  service { 'openstack-setup':
    ensure => running,
    enable => true
  }
}
