# Create an LVM volume group in a file.
class site::openstack::volume_group(
  $vgname = 'cinder-volumes',
  $loop_device = '/dev/loop0',
  $image_file = '/lvm.img',
  $image_size = '4G'
) {
  file { '/etc/rc.lvm':
    ensure  => present,
    content => template('site/openstack/image-vg-create.sh'),
    owner   => 'root',
    group   => 'root',
    mode    => '0555',
  } ->
  exec { '/bin/sh /etc/rc.lvm':
    unless => "/sbin/vgs ${vgname} >/dev/null 2>&1"
  }

  include site::rc_local
}
