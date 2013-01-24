class site::openstack::nova::backup
{
  # Ensure that these classes have been evaluated before, elsewhere.
  # They require parameters, so include statements will fail if they
  # haven't been evaluated already.
  include ::nova::db::mysql

  $database_type     = 'mysql'
  $database_host     = $::nova::db::mysql::host
  $database_user     = $::nova::db::mysql::user
  $database_password = $::nova::db::mysql::password
  $database_name     = $::nova::db::mysql::dbname

  $datadir = '/var/lib/nova' # XXX: hard-coded

  $script_params = {
    datadir => $datadir,
    owner   => 'nova',
    group   => 'nova'
  }

  site::bacula::app_backup { 'openstack:nova':
    app_name          => 'nova',
    service_name      => 'nova-compute',
    database_type     => $database_type,
    database_host     => $database_host,
    database_user     => $database_user,
    database_password => $database_password,
    database_name     => $database_name,
    fileset_include   => $datadir,
    script_params     => $script_params,
    script_fragment   => template('site/openstack/nova/backup.rb.erb')
  }
}
