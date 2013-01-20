# All-in-one Bacula director/storage/client/console role
#
# == Parameters
#
# - *storage_ftp_mirror*: Whether to configure the storage daemon to use
#   an FTP mirror to store and retrieve volumes (+true+), or to use the
#   standard storage daemon configuration that comes with the bacula module
#   and only stores all volumes locally.  See also *storage_ftp_host* and
#   related parameters.
# - *storage_ftp_host*, *storage_ftp_user*, *storage_ftp_password*,
#   *storage_ftp_directory*: Passed as corresponding parameters to the
#   site::bacula::storage::ftp_mirror class
#
# TODO: document remaining parameters
class site::bacula(
  $console_password      = hiera('bacula_console_password'),
  $is_director           = hiera('bacula_is_director', false),
  $director_password     = hiera('bacula_director_password'),
  $is_storage            = hiera('bacula_is_storage', true),
  $storage_ftp_mirror    = hiera('bacula_storage_ftp_mirror', false),
  $storage_ftp_host      = undef,
  $storage_ftp_user      = undef,
  $storage_ftp_password  = undef,
  $storage_ftp_directory = undef
) {
  if $is_storage and $storage_ftp_mirror {
    class { 'site::bacula::storage::ftp_mirror':
      ftp_host      => $storage_ftp_host,
      ftp_user      => $storage_ftp_user,
      ftp_password  => $storage_ftp_password,
      ftp_directory => $storage_ftp_directory
    }

    $storage_template = $site::bacula::storage::ftp_mirror::storage_template
    $director_template = $site::bacula::storage::ftp_mirror::director_template
  } else {
    # Use default templates from "bacula" module.
    $storage_template = undef
    $director_template = undef
  }

  class { '::bacula':
    is_director       => $is_director,
    is_storage        => $is_storage,
    is_client         => true,
    manage_console    => true,
    storage_server    => $::fqdn,
    storage_template  => $storage_template,
    director_server   => $::fqdn,
    director_password => $director_password,
    director_template => $director_template,
    console_password  => $console_password
  }

  if $is_director {
    class { 'site::bacula::director':
      client_password => $director_password
    }
  }

  file { '/etc/bacula/scripts/rm-rf':
    ensure  => present,
    source  => 'puppet:///modules/site/bacula/rm-rf',
    mode    => '0555',
    owner   => 'root',
    group   => 'root',
    require => Package['bacula-sd-sqlite3'] # XXX: Class['bacula::console']
  }

  file { '/etc/bacula/scripts/chown-R':
    ensure  => present,
    source  => 'puppet:///modules/site/bacula/chown-R',
    mode    => '0555',
    owner   => 'root',
    group   => 'root',
    require => Package['bacula-sd-sqlite3'] # XXX: Class['bacula::console']
  }

  file { '/etc/bacula/scripts/bpipe-lvm-vg':
    ensure  => present,
    source  => 'puppet:///modules/site/bacula/bpipe-lvm-vg',
    mode    => '0555',
    owner   => 'root',
    group   => 'root',
    require => Package['bacula-sd-sqlite3'] # XXX: Class['bacula::console']
  }

  file { '/etc/bacula/scripts/lvm-backup':
    ensure  => present,
    source  => 'puppet:///modules/site/bacula/lvm-backup',
    mode    => '0555',
    owner   => 'root',
    group   => 'root',
    require => Package['bacula-sd-sqlite3'] # XXX: Class['bacula::console']
  }

  file { '/etc/bacula/scripts/lvm-restore':
    ensure  => present,
    source  => 'puppet:///modules/site/bacula/lvm-restore',
    mode    => '0555',
    owner   => 'root',
    group   => 'root',
    require => Package['bacula-sd-sqlite3'] # XXX: Class['bacula::console']
  }

  file { '/usr/local/lib/site_ruby/bacula':
    ensure => directory,
    mode   => '0444',
    owner  => 'root',
    group  => 'root'
  }

  file { '/usr/local/sbin/bacula-backup':
    ensure => present,
    source => 'puppet:///modules/site/bacula/bacula-backup',
    mode   => '0555',
    owner  => 'root',
    group  => 'root'
  }

  file { '/usr/local/sbin/bacula-restore':
    ensure => present,
    source => 'puppet:///modules/site/bacula/bacula-restore',
    mode   => '0555',
    owner  => 'root',
    group  => 'root'
  }

  include site::bacula::console
}
