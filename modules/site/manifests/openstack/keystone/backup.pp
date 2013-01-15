class site::openstack::keystone::backup
{
  # Ensure that this class has been evaluated before.  It requires parameters,
  # so include statement will fail if it hasn't been evaluated already.
  include ::keystone::db::mysql

  $database_type     = 'mysql'
  $database_host     = '127.0.0.1'
  $database_user     = $::keystone::db::mysql::user
  $database_password = $::keystone::db::mysql::password
  $database_name     = $::keystone::db::mysql::dbname

  site::bacula::app_backup { 'openstack:keystone':
    app_name          => 'keystone',
    service_name      => 'keystone',
    database_type     => $database_type,
    database_host     => $database_host,
    database_user     => $database_user,
    database_password => $database_password,
    database_name     => $database_name
  }
}
