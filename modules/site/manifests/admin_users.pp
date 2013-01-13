# Manage admin users and their associated resources.
class site::admin_users
{
  package { 'sudo':
    ensure => present
  }

  site::admin_user::backup { 'root':
    group   => 'root',
    homedir => '/root'
  }

  create_resources('site::admin_user', hiera_hash('admin_users', {}))
}
