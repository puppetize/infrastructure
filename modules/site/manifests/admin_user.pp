# Manage site administrator user accounts on this system.
define site::admin_user($ensure = present, $shell = '/bin/bash',
  $fullname = undef, $email = undef, $rsakey = undef,
  $manage_gitconfig = true)
{
  group { $name:
    ensure => $ensure
  }

  user { $name:
    ensure => $ensure
  }

  $sudoers_fragment = "/etc/sudoers.d/${name}"

  file { $sudoers_fragment:
    ensure  => $ensure,
    mode    => '0440',
    owner   => 'root',
    group   => 'root',
    content => "${name} ALL = (ALL) NOPASSWD: ALL\n"
  }

  $homedir = "/home/${name}"

  case $ensure {
    absent: {
      file { $homedir:
        ensure  => absent,
        backup  => false,
        recurse => true,
        force   => true
      }
    }

    present: {
      User[$name] {
        gid     => $name,
        groups  => ['sudo'],
        shell   => $shell,
        require => Package['sudo']
      }

      file { $homedir:
        ensure => directory,
        owner  => $name,
        group  => $name
      }

      File[$sudoers_fragment] {
        require => Package['sudo']
      }

      if $rsakey {
        ssh_authorized_key { "${name}'s RSA key for ${name}":
          user    => $name,
          type    => 'ssh-rsa',
          key     => $rsakey,
          require => File[$homedir]
        }
      }

      if $manage_gitconfig {
        file { "${homedir}/.gitconfig":
          ensure  => present,
          mode    => '0444',
          owner   => $name,
          group   => $name,
          content => template('site/admin_user/.gitconfig')
        }
      }
    }

    default: {
      fail("invalid value for ensure: ${ensure}")
    }
  }
}
