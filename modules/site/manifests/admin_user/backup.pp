define site::admin_user::backup($homedir, $group)
{
  $director_name = $::hostname # FIXME: use hiera

  $pool     = "${director_name}:pool:default"
  $storage  = "${director_name}:storage:default"
  $messages = "${director_name}:messages:standard"
  $fileset  = "${::hostname}:fileset:home:${name}"

  # FIXME: use exported resources, not virtual
  @bacula::director::fileset { $fileset:
    content => template('site/bacula/admin-user-fileset.erb')
  }

  # FIXME: use exported resources, not virtual
  @bacula::director::job { "${::hostname}:backup:home:${name}":
    comment  => "Backup ${homedir}",
    type     => 'Backup',
    schedule => 'Weekly:onMonday',
    client   => $::hostname,
    fileset  => $fileset,
    pool     => $pool,
    storage  => $storage,
    messages => $messages,
    content  => template('site/bacula/admin-user-backup-job.erb')
  }

  # FIXME: use exported resources, not virtual
  @bacula::director::job { "${::hostname}:restore:home:${name}":
    comment  => "Backup ${homedir}",
    type     => 'Restore',
    where    => '/',
    client   => $::hostname,
    fileset  => $fileset,
    pool     => $pool,
    storage  => $storage,
    messages => $messages,
    content  => template('site/bacula/admin-user-restore-job.erb')
  }
}
