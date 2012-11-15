# Simgle-node OpenStack installation.
class site::openstack::all(
  $admin_password,
  $cinder_volumes_size,
  $admin_email = 'root@localhost'
) {
  class { 'site::openstack::volume_group':
    image_size => $cinder_volumes_size
  } ->
  class { '::openstack::all':
    public_interface  => 'eth0',
    public_address    => $ipaddress_eth0,
    fixed_range       => '10.0.2.128/25',

    private_interface => 'eth1',

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

  include apache

  Keystone_tenant <| |>
  Keystone_user <| |>
  Keystone_user_role <| |>
}
