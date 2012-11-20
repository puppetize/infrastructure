# Perform additional OpenStack setup outside of Puppet.
class site::openstack::setup(
  $admin_password,
  $keystone_url = 'http://10.0.2.15:5000/v2.0',
  $vlan = 1000,
  $cirros_image = 'cirros-0.3.0-x86_64-disk',
) {
  $cirros_image_url = "https://launchpad.net/cirros/trunk/0.3.0/+download/${cirros_image}.img"
  $subnet_cidr = '192.168.0.0/24'
  $nameserver = '10.0.2.3'

  file { '/etc/openrc.sh':
    ensure  => present,
    content => template('site/openstack/openrc.sh'),
    mode    => '0440',
    owner   => 'root',
    group   => 'root'
  }

  $dependencies = [
    File['/etc/openrc.sh'],
    Class['glance::api'],
    Class['glance::registry'],
    Class['keystone'],
    Class['nova::api'],
    Class['nova::compute'],
    Class['openstack::keystone'],
    Class['quantum::plugins::ovs'],
    Class['quantum::Keystone::auth'],
  ]

  define quantum_net($vlan)
  {
    exec { "quantum net-create '${name}'":
      command => "/bin/sh -c '. /etc/openrc.sh; /usr/bin/quantum net-create \"${name}\" --provider:network_type vlan --provider:segmentation_id ${vlan} --shared --router:external True'",
      unless  => "/bin/sh -c '. /etc/openrc.sh; /usr/bin/quantum net-show \"${name}\"'"
    }
  }

  define quantum_subnet($net, $subnet_cidr, $nameserver)
  {
    exec { "quantum subnet-create '${name}'":
      command => "/bin/sh -c '. /etc/openrc.sh; /usr/bin/quantum subnet-create --name \"${name}\" \"${net}\" ${subnet_cidr} --dns_nameservers list=true ${nameserver}'",
      unless  => "/bin/sh -c '. /etc/openrc.sh; /usr/bin/quantum subnet-show public'",
      require => Quantum_net[$net]
    }
  }

  quantum_net { 'public':
    vlan    => $vlan,
    require => $dependencies
  }

  quantum_subnet { 'public':
    net         => 'public',
    subnet_cidr => $subnet_cidr,
    nameserver  => $nameserver
  }

  glance_image { $cirros_image:
    ensure           => present,
    is_public        => 'yes',
    container_format => 'bare',
    disk_format      => 'qcow2',
    source           => $cirros_image_url,
    require          => $dependencies
  }
}
