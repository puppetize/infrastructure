class site::bacula::console
{
  require ::bacula::console

  file { '/usr/local/lib/site_ruby/bacula/console.rb':
    ensure => file,
    source => 'puppet:///modules/site/bacula/console.rb',
    mode   => '0444',
    owner  => 'root',
    group  => 'root'
  }
}
