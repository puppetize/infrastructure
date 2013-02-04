$bacula_use_file_concat = true

node 'p1.puppetize.net' {
  include site::admin_users
  include site::bacula
  include site::openstack::all
}

node 'www.puppetize.net' {
  include apache
}
