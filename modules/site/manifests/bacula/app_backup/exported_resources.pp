# Exported resources for site::bacula::app_backup (with storeconfigs enabled)
define site::bacula::app_backup::exported_resources(
  $app_name,
  $client,
  $schedule,
  $storace,
  $messages,
  $fileset,
  $fileset_body,
  $backup_job,
  $backup_job_content,
  $restore_job,
  $restore_job_content
) {
  @@bacula::director::fileset { $fileset:
    content => $fileset_body
  }

  @@bacula::director::job { $backup_job:
    comment  => "Backup \"${app_name}\" files and/or database",
    type     => 'Backup',
    schedule => $schedule,
    client   => $client,
    fileset  => $fileset,
    pool     => $pool,
    storage  => $storage,
    messages => $messages,
    content  => $backup_job_content
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
    content  => $restore_job_content
  }
}
