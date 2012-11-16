# Simgle-node OpenStack installation.
class site::openstack::all(
  $public_interface,
  $public_address,
  $cinder_volumes_size,
  $admin_password,
  $admin_email = 'root@localhost'
) {
  class { 'site::openstack::volume_group':
    image_size => $cinder_volumes_size
  } ->
  class { '::openstack::all':
    public_interface     => $public_interface,
    public_address       => $public_address,
    fixed_range          => '10.0.2.128/25',

    admin_email          => $admin_email,
    admin_password       => $admin_password,

    mysql_root_password  => 'asdf',
    rabbit_password      => 'asdf',
    keystone_admin_token => 'asdf',
    keystone_db_password => 'asdf',
    glance_db_password   => 'asdf',
    glance_user_password => 'asdf',
    nova_db_password     => 'asdf',
    nova_user_password   => 'asdf',
    purge_nova_config    => false,
    secret_key           => 'dummy_secret_key',

    libvirt_type         => 'qemu'
  } 

  # Patch /etc/libvirt/qemu.conf for use with Quantum OVS.
  include site::openstack::libvirt

  # Apache is needed for the OpenStack dashboard (Horizon).
  include apache

  # Realize Nova users and projects defined elsewhere.
  Keystone_tenant <| |>
  Keystone_user <| |>
  Keystone_user_role <| |>
}
