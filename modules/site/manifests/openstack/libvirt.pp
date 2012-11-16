# https://bugs.launchpad.net/ubuntu/+source/libvirt/+bug/1075610
class site::openstack::libvirt
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
