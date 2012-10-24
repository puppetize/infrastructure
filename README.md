What is this?
=============

This repository contains the Puppet code and Vagrant box definitions for the
infrastructure on http://puppetize.net.

Vagrant host requirements
=========================

* VirtualBox 4.0
* Ruby 1.8
  * rake
  * vagrant
  * veewee

Building base boxes for Vagrant
===============================

Execute the following command to build the .box files for all defined base
boxes and then add them to your vagrant installation, unless they exist
already:

``# (cd boxes/base && rake install)``

You can also install the base boxes and destroy them afterwards, in one go,
leaving only the base boxes in vagrant:

``# (cd boxes/base && rake install destroy)``

How do I set up the main Vagrant host?
======================================

Install the base operating system, which for now should be Debian 6 (squeeze),
including [Puppet](http://puppetlabs.com/puppet/what-is-puppet/).  Then clone
this repository and run the following command in the top-level directory of
the working copy:

``# puppet apply --confdir=`pwd` manifests/host.pp``

You could also test the same Puppet manifest in a Vagrant box (but of course,
nested virtual machines may not work that well):

``# (cd boxes/host && vagrant up)``

Supported operating systems
===========================

This infrastructure is known to work with the following operating systems:

* Debian 6.0.6 (squeeze)
  * facter 1.5.7
