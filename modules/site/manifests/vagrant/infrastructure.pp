# Manage the Vagrant host environment.
class site::vagrant::infrastructure(
  $vagrant_home = '/home/vagrant',
  $vagrant_user = 'vagrant',
  $vagrant_group = 'vagrant',
  $vagrant_infrastructure_url = 'https://github.com/puppetize/infrastructure')
{
  include site::git
  include site::vagrant

  $vagrant_infrastructure_home = "${vagrant_home}/infrastructure"

  group { $vagrant_group:
    ensure => present
  }

  user { $vagrant_user:
    ensure => present,
    gid    => $vagrant_group,
    home   => $vagrant_home
  }

  file { $vagrant_home:
    ensure   => directory,
    mode     => '0750',
    owner    => $vagrant_user,
    group    => $vagrant_group,
    require => User[$vagrant_user]
  }

  $git = $site::git::executable

  exec { 'git-clone-vagrant-infrastructure':
    command   => "${git} clone --recursive '${vagrant_infrastructure_url}' ${vagrant_infrastructure_home}",
    creates   => "${vagrant_infrastructure_home}/.git",
    user      => $vagrant_user,
    group     => $vagrant_group,
    logoutput => on_failure,
    require   => [
      File[$vagrant_home],
      Class['site::git']
    ]
  }

  package { 'rake':
    ensure => installed
  }

  cron { 'git-pull-vagrant-infrastructure':
    command => "cd ${vagrant_home}/infrastructure && rake update >/dev/null",
    minute  => '*/30',
    user    => 'vagrant',
    require => [
      Exec['git-clone-vagrant-infrastructure'],
      Package['rake'],
      Class['site::vagrant']
    ]
  }

  file { '/etc/rc.local':
    ensure  => present,
    source  => 'puppet:///modules/site/rc.local',
    mode    => '0555',
    owner   => 'root',
    group   => 'root',
    require => [
      Exec['git-clone-vagrant-infrastructure'],
      Package['rake'],
      Class['site::vagrant']
    ]
  }
}
