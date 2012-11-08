class { 'apache':
}

class { 'openstack::all':
  libvirt_type => 'qemu',
  public_address => $ipaddress
}
