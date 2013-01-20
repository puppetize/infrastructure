class site::openstack::glance::backup
{
  # Ensure that these classes have been evaluated before, elsewhere.
  # They require parameters, so include statements will fail if they
  # haven't been evaluated already.
  include ::glance::db::mysql
  include ::glance::backend::file

  $database_type     = 'mysql'
  $database_host     = '127.0.0.1'
  $database_user     = $::glance::db::mysql::user
  $database_password = $::glance::db::mysql::password
  $database_name     = $::glance::db::mysql::dbname

  $datadir = $glance::backend::file::filesystem_store_datadir

  $script_params = {
    datadir => $datadir,
    owner   => 'glance',
    group   => 'glance'
  }

  site::bacula::app_backup { 'openstack:glance':
    app_name          => 'glance',
    service_name      => 'glance-registry',
    database_type     => $database_type,
    database_host     => $database_host,
    database_user     => $database_user,
    database_password => $database_password,
    database_name     => $database_name,
    fileset_include   => $datadir,
    script_params     => $script_params,
    script_fragment   => template('site/openstack/glance/backup.rb.erb')
  }
}
