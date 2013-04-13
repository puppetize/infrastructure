What is this?
=============

This repository contains [Puppet](http://puppetlabs.com) manifests and
[Vagrant](http://vagrantup.com)/[VeeWee](https://github.com/jedi4ever/veewee#readme)
definitions for the infrastructure of [puppetize.net](http://puppetize.net),
topped with a bunch of high-level [Rake](http://rake.rubyforge.org/) tasks
that tie everything together.

The goal is to make it extremely easy for anyone to set up development
and production environments for the site itself (a
[Ruby on Rails](http://rubyonrails.org/) application) and its underlying
technology stack, such as OpenStack and Puppet.

Requirements for development
============================

The only prerequisites to set up a development environment should be:

* Operating system supported by Vagrant
* Ruby
  * Rake
  * RubyGems
    * Vagrant 1.0.x (because more recent versions are not available as
      a Gem and VeeWee doesn't work with newer Vagrant versions, yet)
* [sudo](http://www.sudo.ws/) (if you're not root)

The Rake tasks then take care of installing Puppet via "gem install",
unless it is already available, because that should work across most
operating systems.  All other dependencies beyond Puppet, like Vagrant,
are then installed with "puppet apply" (no existing Puppet master is
required.)

Building base boxes for Vagrant
===============================

Before you can `vagrant up` the individual virtual machines in the
`boxes/` subdirectory, you have to build the Vagrant base boxes.
Execute the following command to build the required `.box` files and
add them to your Vagrant installation (unless they exist already):

``$ (cd boxes/base && rake install)``

To save disk space, you can remove base box VMs and `.box` files
afterwards, leaving only the installed base boxes in `~/.vagrant.d`:

``$ (cd boxes/base && rake destroy)``
