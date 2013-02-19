# Site-specific Bacula director configuration
class site::bacula::director
{
  include site::bacula::client

  $default_pool = "${::hostname}:pool:default"
  $catalog_pool = "${::hostname}:pool:catalog"
  $default_storage = "${::hostname}:storage:default"
  $default_messages = "${::hostname}:messages:standard"
  $default_catalog = "${::hostname}:sqlite"

  $collect_exported_resources = true
  $collect_virtual_resources = false

  $catalog_backup_job = "${::hostname}:backup:catalog"

  bacula::director::job { $catalog_backup_job:
    comment  => 'Bacula catalog backup',
    type     => 'Backup',
    fileset  => 'Catalog',
    client   => $::hostname,
    schedule => 'Weekly:onMonday',
    pool     => $catalog_pool,
    storage  => $default_storage,
    messages => $default_messages,
    content  => template('site/bacula/catalog-backup-job.erb')
  }

  if $collect_exported_resources {
    Bacula::Director::Fileset <<||>>

    Bacula::Director::Client <<||>> {
      catalog => $default_catalog
    }

    Bacula::Director::Job <<||>> {
      pool     => $default_pool,
      storage  => $default_storage,
      messages => $default_messages
    }
  }

  if $collect_virtual_resources {
    Bacula::Director::Fileset <||>

    Bacula::Director::Client <||> {
      catalog => $default_catalog
    }

    Bacula::Director::Job <| name != $catalog_backup_job |> {
      pool     => $default_pool,
      storage  => $default_storage,
      messages => $default_messages
    }
  }
}
