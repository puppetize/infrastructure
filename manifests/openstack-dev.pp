$admin_password = 'asdf'

class { 'site::openstack::all':
  public_interface    => 'eth0',
  public_address      => $ipaddress_eth0,
  cinder_volumes_size => '4G',
  admin_password      => $admin_password
}

class site::openstack::rc
{
  file { '/etc/rc.postinstall':
    ensure  => present,
    content => template('site/openstack/postinstall.sh'),
    owner   => 'root',
    group   => 'root',
    mode    => '0555',
    notify  => Exec['/etc/rc.postinstall']
  }

  exec { '/etc/rc.postinstall':
    command   => '/etc/rc.postinstall && touch /run/rc.postinstall',
    creates   => '/run/rc.postinstall',
    logoutput => true,
    require   => File['/etc/rc.postinstall'],
  }
}

stage { last: require => Stage['main'] }

class { 'site::openstack::rc':
  stage => last
}

# https://bugs.launchpad.net/ubuntu/+source/libvirt/+bug/1075610
class libvirt_qemu_conf_cgroup_device_acl
{
  $qemu_conf = '/etc/libvirt/qemu.conf'

  file { "${qemu_conf}.puppet":
    ensure  => present,
    source  => 'puppet:///modules/site/openstack/qemu.conf',
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
  }->
  exec { 'add cgroup_device_acl to qemu.conf':
    command => "/bin/cat >> ${qemu_conf} < ${qemu_conf}.puppet",
    unless  => "/bin/grep -q ^cgroup_device_acl ${qemu_conf}",
    require => Package['libvirt-bin'],
    notify  => Service['libvirt-bin']
  }
}

include libvirt_qemu_conf_cgroup_device_acl
