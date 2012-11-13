What is this?
=============

This repository contains [Puppet](http://puppetlabs.com) manifests and
[Vagrant](http://vagrantup.com)/[VeeWee](https://github.com/jedi4ever/veewee#readme)
definitions for the infrastructure of [puppetize.net](http://puppetize.net).
The goal is to use the same tools and definitions to manage multiple
development and production environments.

For example, you can make changes to the infrastructure while you're
offline, test them on your laptop, and submit pull requests on GitHub.
Once a change is merged, the puppetize.net infrastructure updates
itself automatically.

Vagrant host requirements
=========================

* VirtualBox 4.2
* Ruby 1.8
  * Rake
  * Vagrant
  * VeeWee

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

Setting up the Vagrant host
===========================

Install the base operating system, which for now should be Debian 6 (squeeze),
including [Puppet](http://puppetlabs.com/puppet/what-is-puppet/).  Then clone
this repository and run the following command in the top-level directory of
the working copy:

``$ rake puppetize:host``

You could also test the same Puppet manifest in a Vagrant box (but of course,
nested virtual machines may not work that well):

``$ (cd boxes/host && vagrant up)``

Supported operating systems
===========================

This infrastructure is known to work with the following operating systems:

* Debian 6.0.6 (squeeze)
  * facter 1.5.7
