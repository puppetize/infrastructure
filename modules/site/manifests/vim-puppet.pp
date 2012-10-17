# Enable systme-wide Puppet code editing support in Vim.
class site::vim-puppet
{
#  package { 'vim-puppet':
#   ensure => installed
#  }
#
#  exec { 'install-vim-puppet-addon':
#    command => '/usr/bin/vim-addons -w install puppet',
#    creates => '/var/lib/vim/addons/syntax/puppet.vim',
#    require => Package['vim-puppet']
#  }
#
#  file { '/etc/vim/vimrc.local':
#    ensure  => present,
#    mode    => '0444',
#    content => "syntax on\n"
#  }
}
