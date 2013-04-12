# Simgle-node OpenStack installation.
class site::openstack::all(
  $public_interface    = hiera('public_interface'),
  $public_address      = hiera('public_address'),
  $cinder_volumes_size = hiera('cinder_volumes_size'),
  $admin_password      = hiera('admin_password'),
  $admin_email         = hiera('admin_email'),
  $libvirt_type        = hiera('libvirt_type')
) {
  class { 'site::openstack::volume_group':
    image_size => $cinder_volumes_size
  } ->
  class { '::openstack::all':
    public_interface     => $public_interface,
    public_address       => $public_address,
    #fixed_range          => '10.0.2.128/25', # XXX: unused?
    network_vlan_ranges  => 'default:1000:1999,physical',
    bridge_mappings      => ['default:br-virtual', 'physical:br-physical'],

    admin_email          => $admin_email,
    admin_password       => $admin_password,

    mysql_root_password   => 'asdf',
    rabbit_password       => 'asdf',
    keystone_admin_token  => 'asdf',
    keystone_db_password  => 'asdf',
    glance_db_password    => 'asdf',
    glance_user_password  => 'asdf',
    nova_db_password      => 'asdf',
    nova_user_password    => 'asdf',
    quantum_db_password   => 'asdf',
    quantum_user_password => 'asdf',
    purge_nova_config     => false,
    secret_key            => 'dummy_secret_key',

    libvirt_type         => $libvirt_type
  } ->
  class { '::quantum::agents::l3':
    #debug                  => 'True',
    external_network_bridge => 'br-physical',
    auth_tenant             => 'services',
    auth_password           => 'asdf',
    metadata_ip             => $::ipaddress_eth0
  }

  nova_config {
    'default_floating_pool': value => 'public'
  }

  # Evaludate the class, so that class variables of other openstack classes
  # are available to the classes included below.
  include ::openstack::all

  vs_bridge { 'br-physical':
    ensure => present,
    before => Service['quantum-plugin-ovs-service']
  }

  # Patch /etc/libvirt/qemu.conf for use with Quantum OVS.
  include site::openstack::libvirt

  # Force the default charset of the 'nova' database to latin1.
  include site::openstack::nova_db_charset

  # Fix the format of this file to make it pure ini-style.
  #include site::openstack::glance_api_paste_ini

  # Create backup and restore jobs for all OpenStack components.
  #include site::openstack::cinder::backup
  #include site::openstack::glance::backup
  #include site::openstack::quantum::backup
  #include site::openstack::keystone::backup
  #include site::openstack::nova::backup

  # Using binat here (a combination of DNAT and SNAT), mapping public IPv4
  # addresses to private IPv4 addresses from a host-only IPv4 network that
  # acts as the external network for virtual machines.  This is so that we
  # don't have to manage multiple floating IP pools for the various public
  # IPv4 networks that we may take IP addresses out of to assign to VMs.
  include site::iptables

  # Apache is needed for the OpenStack dashboard (Horizon).
  include apache

  # Realize Nova users and projects defined elsewhere.
  Keystone_tenant <| |>
  Keystone_user <| |>
  Keystone_user_role <| |>
}
