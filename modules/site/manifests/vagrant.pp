# Set up Vagrant on this system.
#
# Including this class ensures that the ``vagrant'' executable is
# installed in the system.  The *bindir* class variable will be set to
# the directory where the executable is expected to be installed.
#
# == Class Variables
#
# - *bindir*: Absolute path to the directory containing the ``vagrant''
#   executable.  Users of this class want to use "${bindir}/vagrant", most
#   likely, or add the *bindir* path to their shell's *PATH* variable.
class site::vagrant
{
  package { 'vagrant':
    provider => gem,
    ensure   => installed
  }

  case $::operatingsystem {
    Debian: {
      if versioncmp($::operatingsystemrelease, '7') < 0 {
        # squeeze and earlier
        Package['vagrant'] {
          require  => Package['rubygems']
        }

        # FIXME: don't hard-code the Ruby version and gemdir here
        #$bindir = "${ruby::gems::gemdir}/bin"
        $bindir = '/var/lib/gems/1.8/bin'
      } else {
        # wheezy and later - I'm looking into the future here.
        $bindir = '/usr/bin'
      }
    }

    Ubuntu: {
      # We're assuming that this package has always existed, but since
      # when does the ``vagrant'' package really exist in Ubuntu?
      $bindir = '/usr/bin'
    }

    default: {
      fail("Unknown operating system: ${::operatingsystem}")
    }
  }
}
