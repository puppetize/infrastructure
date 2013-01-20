class site::openstack::cinder::backup
{
  # Ensure that these classes have been evaluated before, elsewhere.
  # They require parameters, so include statements will fail if they
  # haven't been evaluated already.
  include ::cinder::db::mysql

  $database_type     = 'mysql'
  $database_host     = $::cinder::db::mysql::host
  $database_user     = $::cinder::db::mysql::user
  $database_password = $::cinder::db::mysql::password
  $database_name     = $::cinder::db::mysql::dbname

  $datadir = '/var/lib/cinder/volumes'

  $script_params = {
    datadir => $datadir,
    owner   => 'cinder',
    group   => 'cinder'
  }

  $fileset_include = $datadir

  site::bacula::app_backup { 'openstack:cinder':
    app_name          => 'cinder',
    service_name      => 'cinder-volume',
    database_type     => $database_type,
    database_host     => $database_host,
    database_user     => $database_user,
    database_password => $database_password,
    database_name     => $database_name,
    fileset_include   => $fileset_include,
    fileset_content   => template('site/openstack/cinder/fileset.erb'),
    script_fragment   => template('site/openstack/cinder/backup.rb.erb'),
    script_params     => $script_params
  }
}
