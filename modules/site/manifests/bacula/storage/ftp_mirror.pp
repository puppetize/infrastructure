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

  # XXX: hard-coded values :(
  $bacula_user = 'bacula'
  $bacula_group = 'bacula'
  $bacula_storage_dir = '/mnt/bacula/default'

  file { '/etc/bacula/scripts/ftp-mirror':
    ensure  => present,
    content => template('site/bacula/ftp-mirror.sh.erb'),
    mode    => '0750',
    owner   => $bacula_user,
    group   => $bacula_group,
    require => Class['bacula::common'],
    before  => Service['bacula-sd']
  }
}
