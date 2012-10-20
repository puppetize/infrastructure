# Install Git.
#
# == Class Variables
#
# - *executable*: absolute path to the 'git' executable
class site::git
{
  package { 'git':
    ensure => installed
  }

  $executable = '/usr/bin/git'
}
