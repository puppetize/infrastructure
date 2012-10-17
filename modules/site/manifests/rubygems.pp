# Site-specific RubyGems setup, fixing PATH problem on Debian
class site::rubygems
{
  package { 'rubygems':
    ensure => installed
  }

  file { '/etc/profile.d/gem.sh':
    ensure  => present,
    mode    => '0444',
    owner   => 'root',
    group   => 'root',
    source  => 'puppet:///modules/site/gem.sh',
    require => Package['rubygems']
  }
}
