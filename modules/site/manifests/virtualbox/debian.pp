# Install VirtualBox on a Ddebian operating system.
#
# == Parameters
#
# - *ose*: whether to install the open-source edition (OSE) instead of
#   Oracle's version of VirtualBox.  Defaults to +true+ because Debian
#   doesn't support Oracle's VirtualBox officially.
# - *default*: source for the +/etc/default/virtualbox+ file resource.
#   Set this to +false+ to leave the file unmanaged.  You can also give
#   an array of values.  See the description of Puppet's *file* resource
#   for more information.
class site::virtualbox::debian(
  $ose = true,
  $default = 'puppet:///modules/site/virtualbox/debian/default')
{
  if $ose {
    $package_name = 'virtualbox-ose'
  } else {
    $package_name = 'virtualbox'
  }

  package { $package_name:
    ensure => installed
  }

  if $default {
    # Manage the configuration file for the virtualbox initscript.
    file { '/etc/default/virtualbox':
      ensure  => present,
      mode    => '0444',
      owner   => 'root',
      group   => 'root',
      source  => $default,
      require => Package[$package_name]
    }
  }
}
