# Create an LVM volume group in a file.
class site::openstack::volume_group(
  $vgname = 'cinder-volumes',
  $loop_device = '/dev/loop0',
  $image_file = '/lvm.img',
  $image_size = '4G'
) {
  file { '/etc/init.d/cinder-volumes-vg':
    ensure  => present,
    content => template('site/openstack/cinder-volumes-vg.init'),
    owner   => 'root',
    group   => 'root',
    mode    => '0555',
  } ->
  service { 'cinder-volumes-vg':
    ensure => running,
    enable => true,
    notify => Service['cinder-volume']
  }
}
