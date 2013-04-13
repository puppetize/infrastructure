# Install 'veewee' extension for building base boxes from scratch.
class site::vagrant::veewee
{
  require site::vagrant

  case $::osfamily {
    Debian: {
      $packages = [
        'libxml2-dev',
        'libxslt1-dev',	# libxslt-dev
        'zlib1g-dev'	# libz-dev
      ]
    }

    default: {
      fail("unknown operating system family: ${::osfamily}")
    }
  }

  package { $packages:
    ensure => installed
  }

  # XXX: horrible hack made necessary because vagrant and fog depend
  # on different versions of net-scp (fog needs a newer version than
  # vagrant.)
  package { 'fog':
    provider => gem,
    ensure   => '1.9.0',
    before   => Package['veewee'],
    require  => Package[$packages]
  }

  package { 'veewee':
    provider => gem,
    ensure   => installed,
    require  => Package[$packages]
  }
}
