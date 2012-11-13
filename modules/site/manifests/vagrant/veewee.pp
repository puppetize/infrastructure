# Install 'veewee' extension for building base boxes from scratch.
class site::vagrant::veewee
{
  case $::osfamily {
    Debian: {
      $packages = [
        'libxml2-dev',
        'libxslt1-dev',	# libxslt-dev
        'zlib1g-dev'	# libz-dev
      ]
    }

    default: {
      fail("unknown operating system: ${::operatingsystem}")
    }
  }

  package { $packages:
    ensure => present
  }

  package { 'veewee':
    ensure   => present,
    provider => gem,
    require  => [
      Class['site::rubygems'],
      Package[$packages]
    ]
  }
}
