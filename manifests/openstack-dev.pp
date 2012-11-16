$admin_password = 'asdf'

class { 'site::openstack::all':
  public_interface    => 'eth0',
  public_address      => $ipaddress_eth0,
  cinder_volumes_size => '4G',
  admin_password      => $admin_password
}->
class { 'site::openstack::setup':
  admin_password => $admin_password
}
