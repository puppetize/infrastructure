# Site-specific Bacula director configuration
class site::bacula::director(
  $client_password
) {
  bacula::director::client { $::hostname:
    password => $client_password,
    catalog  => "${::hostname}:sqlite"
  }

  bacula::director::job { "${::hostname}:backup:catalog":
    comment  => 'Bacula catalog backup',
    type     => 'Backup',
    fileset  => 'Catalog',
    client   => $::hostname,
    schedule => 'Weekly:onMonday',
    pool     => "${::hostname}:pool:catalog",
    storage  => "${::hostname}:storage:default",
    messages => "${::hostname}:messages:standard",
    content  => template('site/bacula/catalog-backup-job.erb')
  }

  Bacula::Director::Fileset <<||>>
  Bacula::Director::Client <<||>>
  Bacula::Director::Job <<||>> {
    #pool     => "${::hostname}:pool:default",
    #storage  => "${::hostname}:storage:default",
    #messages => "${::hostname}:pool:standard"
  }

  # FIXME: use exported resources only, not virtual
  Bacula::Director::Fileset <||>
  Bacula::Director::Client <||>
  Bacula::Director::Job <||> {
    #pool     => "${::hostname}:pool:default",
    #storage  => "${::hostname}:storage:default",
    #messages => "${::hostname}:messages:standard"
  }
}
