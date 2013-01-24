class site::openstack::quantum::backup
{
  # Ensure that these classes have been evaluated before, elsewhere.
  # They require parameters, so include statements will fail if they
  # haven't been evaluated already.
  include ::quantum::db::mysql

  $database_type     = 'mysql'
  $database_host     = $::quantum::db::mysql::host
  $database_user     = $::quantum::db::mysql::user
  $database_password = $::quantum::db::mysql::password
  $database_name     = $::quantum::db::mysql::dbname

  $datadir = '/var/lib/quantum' # XXX: hard-coded

  $script_params = {
    datadir => $datadir,
    owner   => 'quantum',
    group   => 'quantum'
  }

  site::bacula::app_backup { 'openstack:quantum':
    app_name          => 'quantum',
    service_name      => 'quantum-server',
    database_type     => $database_type,
    database_host     => $database_host,
    database_user     => $database_user,
    database_password => $database_password,
    database_name     => $database_name,
    fileset_include   => $datadir,
    script_params     => $script_params,
    script_fragment   => template('site/openstack/quantum/backup.rb.erb')
  }
}
