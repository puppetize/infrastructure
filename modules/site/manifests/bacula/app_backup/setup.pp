# Manage common resources for all application backups
class site::bacula::app_backup::setup
{
  package { 'ruby-mysql':
    ensure => installed
  }
}
