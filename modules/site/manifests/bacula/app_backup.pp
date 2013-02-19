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
# - *fileset_include*: additional lines for the "FileSet"'s "Include"
#   section.  This should specify the files to back up, maybe in conjunction
#   with *fileset_content*.
#
# - *fileset_content*: additional text fragment to append to the generated
#   "FileSet" resource.  This should specify the files to back up, if any.
#   For simple cases you should use the *fileset_include* parameter.
#
# - *script_params*: additional config parameters (a hash) for the backup
#   and restore scripts.
#
# - *script_fragment*: additional Ruby code fragment for the backup and
#   restore scripts.
define site::bacula::app_backup(
  $app_name = $name,
  $job_suffix = $name,
  $service_name = undef,
  $database_type = undef,
  $database_host = undef,
  $database_user = undef,
  $database_password = undef,
  $database_name = undef,
  $fileset_include = [],
  $fileset_content = '',
  $script_params = {},
  $script_fragment = ''
) {
  require site::bacula::app_backup::setup

  $director_name = $::hostname # FIXME: use hiera

  $client   = $::hostname
  $pool     = "${director_name}:pool:default"
  $storage  = "${director_name}:storage:default"
  $messages = "${director_name}:messages:standard"

  $fileset     = "${client}:fileset:${job_suffix}"
  $backup_job  = "${client}:backup:${job_suffix}"
  $restore_job = "${client}:restore:${job_suffix}"

  if $database_type {
    $db_backup  = "/usr/local/sbin/${app_name}-backup-${database_type}"
    $db_restore = "/usr/local/sbin/${app_name}-restore-${database_type}"

    file { $db_backup:
      ensure  => present,
      content => template("site/bacula/app_backup/${database_type}-backup"),
      mode    => '0555',
      owner   => 'root',
      group   => 'root'
    }

    file { $db_restore:
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

  $exported_resources = true
  $virtual_resources = false

  if $exported_resources and $virtual_resources {
    fail('cannot use both, exported resources and virtual resources')
  }

  if $exported_resources {
    @@bacula::director::fileset { $fileset:
      content => $fileset_body
    }

    @@bacula::director::job { $backup_job:
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

    @@bacula::director::job { $restore_job:
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
  }

  if $virtual_resources {
    @bacula::director::fileset { $fileset:
      content => $fileset_body
    }

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
  }


  $base_params = {
    client       => $client,
    job_suffix   => $job_suffix,
    service_name => $service_name
  }

  $config_yaml_content = merge($script_params, $base_params)

  file { $config_yaml:
    ensure  => present,
    content => hash_to_yaml($config_yaml_content),
    mode    => '0440',
    owner   => 'root',
    group   => 'root',
    require => Package['bacula-console']
  }

  $app_backup_head = template('site/bacula/app_backup/backup.rb.erb')
  $app_backup_tail = "if \$0 == __FILE__\n  exit BaculaAppBackup.run!\nend\n"
  $app_backup_body = "${app_backup_head}${script_fragment}${app_backup_tail}"

  $app_restore_head = template('site/bacula/app_backup/restore.rb.erb')
  $app_restore_tail = "if \$0 == __FILE__\n  exit BaculaAppRestore.run!\nend\n"
  $app_restore_body = "${app_restore_head}${script_fragment}${app_restore_tail}"

  $script_depends = [
    File[$config_yaml],
    Class['site::bacula::console'],
    Package['ruby-mysql']
  ]

  file { $app_backup:
    ensure  => present,
    content => $app_backup_body,
    mode    => '0550',
    owner   => 'root',
    group   => 'root',
    require => $script_depends
  }

  file { $app_restore:
    ensure  => present,
    content => $app_restore_body,
    mode    => '0550',
    owner   => 'root',
    group   => 'root',
    require => $script_depends
  }
}
