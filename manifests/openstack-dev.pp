$myuser = 'uwe'
$myproject = 'uwe'

file { '/etc/libvirt/qemu.conf':
  ensure  => present,
  source  => 'puppet:///modules/site/qemu.conf',
  owner   => 'root',
  group   => 'root',
  mode    => '0444',
  require => Package['libvirt-bin'],
  notify  => Service['libvirt-bin']
}

file { '/etc/libvirt/qemu/networks/default.xml':
  ensure  => absent,
  require => Package['libvirt-bin'],
  before  => Service['libvirt-bin']
}

file { '/etc/rc.local':
  ensure  => present,
  content => "[ -r /etc/rc.lvm ] && sh /etc/rc.lvm\n",
  owner   => 'root',
  group   => 'root',
  mode    => '0555'
}

file { '/etc/rc.lvm':
  ensure => present,
  source => 'puppet:///modules/site/lvm.sh',
  owner  => 'root',
  group  => 'root',
  mode   => '0555',
} ->

exec { '/bin/sh /etc/rc.lvm':
  unless => '/sbin/vgs cinder-volumes >/dev/null 2>&1',
} ->

class { 'openstack::all':
  public_interface  => 'eth0',
  public_address    => $ipaddress_eth0,
  fixed_range       => '10.0.2.128/25',

  private_interface => 'eth1',

  admin_email          => 'root@localhost',
  admin_password       => 'asdf',

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
} ->

keystone_tenant { $myproject:
  ensure      => present,
  enabled     => 'True',
  description => 'My Project',
} ->

keystone_user { $myuser:
  ensure   => present,
  enabled  => 'True',
  tenant   => $myproject,
  email    => 'uwe+puppetize@bsdx.de',
  password => 'uwe'
} ->

keystone_user_role { "${myuser}@${myproject}":
  roles  => 'Member',
  ensure => present,
}

include apache
