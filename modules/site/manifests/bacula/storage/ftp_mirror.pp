# Set up FTP mirroring for stored backup volumes
#
# == Parameters
#
# - *ftp_host*, *ftp_user*, *ftp_password*: FTP connection information
# - *ftp_directory*: Directory on the FTP server (default: "/").  The
#   directory will be created if it doesn't exist already.
#
# Default values for all parameters are looked up in the hiera database
# under the prefix "bacula_storage_".
class site::bacula::storage::ftp_mirror(
  $ftp_host      = hiera('bacula_storage_ftp_host'),
  $ftp_user      = hiera('bacula_storage_ftp_user'),
  $ftp_password  = hiera('bacula_storage_ftp_password'),
  $ftp_directory = hiera('bacula_storage_ftp_directory', '/')
) {
  # Use this this template for bacula-sd.conf if you include this class.
  $storage_template = 'site/bacula/bacula-sd.conf.erb'
  $director_template = 'site/bacula/bacula-dir.conf.erb'

  # XXX: hard-coded values :(
  $bacula_storage_dir = '/mnt/bacula/default'
  $bacula_user = 'bacula'
  $bacula_group = 'bacula'
  $tape_group = 'tape'

  package { 'lftp':
    ensure => installed
  }

  file { '/etc/bacula/bacula-ftp-mirror.yaml':
    ensure  => present,
    content => template('site/bacula/ftp-mirror.yaml.erb'),
    mode    => '0440',
    owner   => $bacula_user,
    group   => $bacula_group,
    require => Package['bacula-sd-sqlite3'] # XXX: Class['bacula::console']
  }

  file { '/usr/local/sbin/bacula-ftp-mirror':
    ensure  => present,
    source  => 'puppet:///modules/site/bacula/ftp-mirror',
    mode    => '0555',
    owner   => $bacula_user,
    group   => $bacula_group,
    require => [
      File['/etc/bacula/bacula-ftp-mirror.yaml'],
      Package['bacula-sd-sqlite3'], # XXX: Class['bacula::console']
      Package['lftp']
    ],
    before  => Service['bacula-sd']
  }
}
