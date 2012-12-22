# All-in-one Bacula director/storage/client/console role
class site::bacula(
  $director_password = hiera('bacula_director_password'),
  $console_password  = hiera('bacula_console_password')
) {
  class { '::bacula':
    is_director       => true,
    is_storage        => true,
    is_client         => true,
    manage_console    => true,
    storage_server    => $::fqdn,
    storage_template  => 'site/bacula/bacula-sd.conf.erb',
    director_server   => $::fqdn,
    director_password => $director_password,
    console_password  => $console_password
  }

  # Bacula/FTP setup for Hetzner's root server

  $ftp_host = hiera('ftp_host')
  $ftp_user = hiera('ftp_user')
  $ftp_password = hiera('ftp_password')
  $ftp_directory = hiera('ftp_directory', '/')

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
