# Define typical application backup and restore resources for Bacula
#
# == Parameters
#
# - *app_name*: short name of the application as used in the names of
#   script files, for example. (default: *name*)
#
# - *job_suffix*: suffix for backup and restore jobs in Bacula. (default:
#   *name*)
#
# - *database_type*, *database_host*, *database_user*, *database_password*,
#   *database_name*: database connection information, if the application
#   uses a database.  Database backups are included in the backup/restore
#   job definitions if *database_type* is set.  (default: +undef+)
#
# - *fileset_content*: additional text fragment to append to the generated
#   "FileSet" resource.  This should specify the files to back up, if any.
define site::bacula::app_backup(
  $app_name = $name,
  $job_suffix = $name,
  $service_name = undef,
  $database_type = undef,
  $database_host = undef,
  $database_user = undef,
  $database_password = undef,
  $database_name = undef,
  $fileset_content = ''
) {
  $director_name = $::hostname # FIXME: use hiera

  $client   = $::hostname
  $pool     = "${director_name}:pool:default"
  $storage  = "${director_name}:storage:default"
  $messages = "${director_name}:messages:standard"

  $fileset     = "${client}:fileset:${job_suffix}"
  $backup_job  = "${client}:backup:${job_suffix}"
  $restore_job = "${client}:restore:${job_suffix}"

  $backup_script  = "/usr/local/sbin/${app_name}-backup"
  $restore_script = "/usr/local/sbin/${app_name}-restore"

  if $database_type {
    $backup_database  = "/usr/local/sbin/${app_name}-backup-${database_type}"
    $restore_database = "/usr/local/sbin/${app_name}-restore-${database_type}"

    file { $backup_database:
      ensure  => present,
      content => template("site/bacula/app_backup/${database_type}-backup"),
      mode    => '0555',
      owner   => 'root',
      group   => 'root'
    }

    file { $restore_database:
      ensure  => present,
      content => template("site/bacula/app_backup/${database_type}-restore"),
      mode    => '0555',
      owner   => 'root',
      group   => 'root'
    }
  }

  $config_yaml = "/etc/bacula/${app_name}.yaml"
  $app_backup  = "/usr/local/sbin/${app_name}-backup"
  $app_restore = "/usr/local/sbin/${app_name}-restore"

  $fileset_head = template('site/bacula/app_backup/fileset.erb')
  $fileset_body = "${fileset_head}${fileset_content}"

  # FIXME: use exported resources, not virtual
  @bacula::director::fileset { $fileset:
    content => $fileset_body
  }

  # FIXME: use exported resources, not virtual
  @bacula::director::job { $backup_job:
    comment  => "Backup \"${app_name}\" files and/or database",
    type     => 'Backup',
    schedule => 'Weekly:onSunday',
    client   => $client,
    fileset  => $fileset,
    pool     => $pool,
    storage  => $storage,
    messages => $messages,
    content  => template('site/bacula/app_backup/backup-job.erb')
  }

  # FIXME: use exported resources, not virtual
  @bacula::director::job { $restore_job:
    comment  => "Restore \"${app_name}\" files and/or database",
    type     => 'Restore',
    where    => '/',
    client   => $client,
    fileset  => $fileset,
    pool     => $pool,
    storage  => $storage,
    messages => $messages,
    content  => template('site/bacula/app_backup/restore-job.erb')
  }

  file { $config_yaml:
    ensure  => present,
    content => template('site/bacula/app_backup/config.yaml'),
    mode    => '0440',
    owner   => 'root',
    group   => 'root',
    require => Package['bacula-console']
  }

  package { 'ruby-mysql':
    ensure => installed
  }

  file { $app_backup:
    ensure  => present,
    content => template('site/bacula/app_backup/backup.rb.erb'),
    mode    => '0555',
    owner   => 'root',
    group   => 'root',
    require => [
      File[$config_yaml],
      Class['site::bacula::console']
    ]
  }

  file { $app_restore:
    ensure  => present,
    content => template('site/bacula/app_backup/restore.rb.erb'),
    mode    => '0555',
    owner   => 'root',
    group   => 'root',
    require => [
      File[$config_yaml],
      Class['site::bacula::console'],
      Package['ruby-mysql']
    ]
  }
}
