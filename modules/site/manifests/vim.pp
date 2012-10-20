# Site-specific setup of Vim.
#
# == Class Variables
#
# - *addons_dir*: directory where Vim searches for system-wide addons
# - *autoload_dir*: directory where Vim searches for system-wide auto-loadable
#   functions
#
# == See Also
#
# - site::vim::pathogen
# - site::vim::puppet
class site::vim
{
  case $::operatingsystem {
    Debian, Ubuntu: {
      $addons_dir = '/var/lib/vim/addons'
      $autoload_dir = "${addons_dir}/autoload"
      $package = 'vim'

      file { $autoload_dir:
        ensure  => directory,
        owner   => 'root',
        group   => 'root',
        require => Package[$package]
      }
    }

    default: {
      fail("unknown operating system: ${::operatingsystem}")
    }
  }

  package { $package:
    ensure => installed
  }
}
