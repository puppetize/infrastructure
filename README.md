About This Project
==================

The infrastructure project focuses on building the OpenStack private
cloud that will host the online tutorial application and eventually
the whole of [puppetize.net](http://puppetize.net). It builds on the
[OpenStack modules](https://github.com/puppetlabs/puppetlabs-openstack)
developed by Dan Bode (@bodepd) at PuppetLabs and includes Vagrant
boxes and RSpec definitions for test-driven development.

The goal is to make it extremely easy to participate in the development
of the site itself and its underlying technology stack, such as OpenStack
and Puppet.

Getting Started
===============

Before you begin, make sure that you have
[Vagrant](http://vagrantup.com),
[VeeWee](https://github.com/jedi4ever/veewee) and
[Rake](http://rake.rubyforge.org/) installed and working.

Clone the [infrastructure](https://github.com/puppetize/infrastructure)
repository recursively, including all referenced submodules.
```
$ git clone --recursive git@github.com:puppetize/infrastructure
```

Building Baseboxes
------------------

To using the provided Vagrant box definitions, you must have the required
baseboxes.  They can be built using VeeWee and there is a Rake task which
makes this a one-steop process.

```
$ (cd boxes/base && rake install)
```

This will download the installation media for all supported operating
systems, perform a non-interactive installtion, build Vagrant box
packages (in the boxes/base directory) and install those packages into
vagrant.

Afterwards, you can free up some disk space by deleting the Vagrant box
package files.
```
$ (cd boxes/base && rake destroy)
```

OpenStack Cloud Controller
--------------------------

...
