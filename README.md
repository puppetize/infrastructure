What is this?
=============

This repository contains the Puppet code and Vagrant box definitions for the
infrastructure on http://puppetize.net.

How do I set up the main Vagrant host?
======================================

Install the base operating system, which for now should be Debian 6 (squeeze),
including [Puppet](http://puppetlabs.com/puppet/what-is-puppet/).  Then clone
this repository and run the following command in the top-level directory of
the working copy:

``# puppet apply --confdir=`pwd` manifests/host.pp``

You could also test the same Puppet manifest in a Vagrant box (but of course,
nested virtual machines may not work that well):

``# cd boxes/host; vagrant up``
