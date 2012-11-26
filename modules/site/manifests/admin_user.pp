# Manage site administrator user accounts on this system.
define site::admin_user(
  $authorized_keys,
  $ensure = present,
  $shell = '/bin/bash',
  $email = undef,
  $fullname = undef,
  $manage_gitconfig = false,
  $keystone_password = undef)
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

      site::admin_user::authorized_keys { $name:
        authorized_keys => $authorized_keys,
        require         => File[$homedir]
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

      if $keystone_password and $email {
        @keystone_user { $name:
          ensure   => present,
          enabled  => 'True',
          tenant   => $name,
          email    => $email,
          password => $keystone_password,
        }

        @keystone_tenant { $name:
          ensure      => present,
          enabled     => 'True',
          description => "${name}'s project",
        }

        @keystone_user_role { "${name}@${name}":
          roles   => 'Member',
          ensure  => present,
          require => [
            Keystone_user[$name],
            Keystone_tenant[$name]
          ]
        }
      }
    }

    default: {
      fail("invalid value for ensure: ${ensure}")
    }
  }
}
