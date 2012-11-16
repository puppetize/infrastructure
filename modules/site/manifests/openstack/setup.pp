# Perform additional OpenStack setup outside of Puppet.
class site::openstack::setup(
  $admin_password
) {
  file { '/etc/init.d/openstack-setup':
    ensure  => present,
    content => template('site/openstack/openstack-setup.init'),
    owner   => 'root',
    group   => 'root',
    mode    => '0555',
  } ->
  service { 'openstack-setup':
    ensure  => running,
    enable  => true,
    require => [
      Class['nova::api'],
      Class['nova::compute'],
      Class['quantum::plugins::ovs']
    ]
  }
}
