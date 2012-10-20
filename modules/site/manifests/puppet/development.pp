# Set up development support for Puppet manifests.
class site::puppet::development
{
  require site::rubygems
  require site::vim::puppet

  $gem_packages = [
    'librarian-puppet',
    'puppet-module',
    'cucumber-puppet',
    'rspec-puppet',
    'puppet-lint',
  ]

  package { $gem_packages:
    ensure   => present,
    provider => gem,
    require  => Class['site::rubygems']
  }
}
