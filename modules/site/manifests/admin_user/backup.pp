define site::admin_user::backup($homedir, $group)
{
  $director_name = $::hostname # FIXME: use hiera

  $client   = $::hostname
  $pool     = "${director_name}:pool:default"
  $storage  = "${director_name}:storage:default"
  $messages = "${director_name}:messages:standard"
  $fileset  = "${client}:fileset:home:${name}"

  # FIXME: use exported resources, not virtual
  @bacula::director::fileset { $fileset:
    content => template('site/bacula/admin-user-fileset.erb')
  }

  # FIXME: use exported resources, not virtual
  @bacula::director::job { "${client}:backup:home:${name}":
    comment  => "Backup ${name}'s home directory (${homedir})",
    type     => 'Backup',
    schedule => 'Weekly:onMonday',
    client   => $client,
    fileset  => $fileset,
    pool     => $pool,
    storage  => $storage,
    messages => $messages,
    content  => template('site/bacula/admin-user-backup-job.erb')
  }

  # FIXME: use exported resources, not virtual
  @bacula::director::job { "${client}:restore:home:${name}":
    comment  => "Restore ${name}'s home directory (${homedir})",
    type     => 'Restore',
    where    => '/',
    client   => $client,
    fileset  => $fileset,
    pool     => $pool,
    storage  => $storage,
    messages => $messages,
    content  => template('site/bacula/admin-user-restore-job.erb')
  }
}
