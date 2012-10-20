# Enable the pathogen Vim bundle manager for all users.
#
# == Class Variables
#
# - *bundle_dir*: directory in which to install system-wide bundles, where
#   pathogen can find them
class site::vim::pathogen
{
  include site::vim

  $bundle_dir = "${site::vim::addons_dir}/bundle"

  file { "${site::vim::autoload_dir}/pathogen.vim":
    ensure  => present,
    mode    => '0444',
    owner   => 'root',
    group   => 'root',
    source  => 'puppet:///modules/site/vim/pathogen.vim',
    require => File[$site::vim::autoload_dir]
  }

  file { $bundle_dir:
    ensure  => directory,
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    require => File["${site::vim::autoload_dir}/pathogen.vim"]
  }

  file { '/etc/vim/vimrc.local':
    ensure  => present,
    mode    => '0444',
    owner   => 'root',
    group   => 'root',
    source  => 'puppet:///modules/site/vim/vimrc.local',
    require => File[$bundle_dir]
  }
}
