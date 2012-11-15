$admin_password = 'asdf'

class { 'site::openstack::all':
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
