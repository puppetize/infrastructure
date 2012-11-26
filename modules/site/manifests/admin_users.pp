# Manage admin users and their associated resources.
class site::admin_users
{
  package { 'sudo':
    ensure => present
  }

  create_resources('site::admin_user', hiera_hash('admin_users', {}))
}
