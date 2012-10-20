# Enable systme-wide Puppet code editing support in Vim.
#
# == References
#
# - http://jedi.be/blog/2011/12/05/puppet-editing-like-a-pro/
class site::vim::puppet
{
  $bundle_sources = {
    'vim-ruby-debugger' => 'git://github.com/astashov/vim-ruby-debugger.git',
    'supertab'          => 'git://github.com/ervandew/supertab.git',
    'tabular'           => 'git://github.com/godlygeek/tabular.git',
    #'vim-rdoc'          => 'git://github.com/hallison/vim-rdoc.git',
    'snipmate.vim'      => 'git://github.com/msanders/snipmate.vim.git',
    'vim-javascript'    => 'git://github.com/pangloss/vim-javascript.git',
    'nerdtree'          => 'git://github.com/scrooloose/nerdtree.git',
    'textile.vim'       => 'git://github.com/timcharper/textile.vim.git',
    'vim-cucumber'      => 'git://github.com/tpope/vim-cucumber.git',
    'vim-fugitive'      => 'git://github.com/tpope/vim-fugitive.git',
    'vim-git'           => 'git://github.com/tpope/vim-git.git',
    'vim-haml'          => 'git://github.com/tpope/vim-haml.git',
    'vim-markdown'      => 'git://github.com/tpope/vim-markdown.git',
    'vim-rails'         => 'git://github.com/tpope/vim-rails.git',
    'vim-repeat'        => 'git://github.com/tpope/vim-repeat.git',
    'vim-surround'      => 'git://github.com/tpope/vim-surround.git',
    'vim-vividchalk'    => 'git://github.com/tpope/vim-vividchalk.git',
    #'taskpaper.vim'     => 'git://github.com/tsaleh/taskpaper.vim.git',
    'vim-matchit'       => 'git://github.com/tsaleh/vim-matchit.git',
    'vim-shoulda'       => 'git://github.com/tsaleh/vim-shoulda.git',
    #'vim-tcomment'      => 'git://github.com/tsaleh/vim-tcomment.git',
    'vim-tmux'          => 'git://github.com/tsaleh/vim-tmux.git',
    'vim-ruby'          => 'git://github.com/vim-ruby/vim-ruby.git',
    'Gist.vim'          => 'git://github.com/vim-scripts/Gist.vim.git',
    'syntastic'         => 'git://github.com/scrooloose/syntastic',
    'vim-puppet'        => 'git://github.com/rodjek/vim-puppet.git',
    'Specky'            => 'git://github.com/vim-scripts/Specky.git',
  }

  $bundle_names = keys($bundle_sources)

  package { 'curl':
    ensure => installed,
    before => Site::Vim::Pathogen::Git_bundle['Gist.vim']
  }

  site::vim::pathogen::git_bundle { $bundle_names:
    source => $bundle_sources
  }
}
