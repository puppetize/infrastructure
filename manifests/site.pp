$bacula_use_file_concat = true

node default
{
  include site::admin_users
  include site::bacula
}

node 'p1.puppetize.net' inherits default
{
  include site::openstack::all
}

node 'p2.puppetize.net' inherits default
{
  include site::openstack::all
}

node 'puppet.puppetize.net' inherits default
{
  # TODO
  include site::vim::puppet
}

node 'www.puppetize.net' inherits default
{
  # TODO
  include apache
}
