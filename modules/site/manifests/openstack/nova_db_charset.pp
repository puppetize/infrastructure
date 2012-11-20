class site::openstack::nova_db_charset
{
  $mysql = '/usr/bin/mysql --defaults-file=/root/.my.cnf'

  exec { "${mysql} -e 'alter database nova CHARACTER SET latin1'":
    unless      => "${mysql} -e 'show create database nova' | grep -q latin1",
    refreshonly => true,
    subscribe   => Exec['keystone-manage db_sync', 'nova-db-sync']
  }
}
