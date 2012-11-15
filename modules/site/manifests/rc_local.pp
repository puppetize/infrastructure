# Arrange for any /etc/rc.* scripts to be run on boot.
class site::rc_local
{
  file { '/etc/rc.local':
    ensure  => present,
    content => "(for f in /etc/rc.*; do [ \$f = /etc/rc.local ] && continue; echo Running \$f...; sh -x \$f; done) 2>&1 | tee -a /var/log/rc.log\n",
    owner   => 'root',
    group   => 'root',
    mode    => '0555'
  }
}
