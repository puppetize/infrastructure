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
  } else {
    $storage_template = undef # use default template from bacula module
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
    console_password  => $console_password
  }

  if $is_director {
    #bacula::director::job { "${::fqdn}:backup:bacula":
    #}
  }
}
