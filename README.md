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

Base boxes for the included Vagrant boxes can be built using VeeWee and
there is a Rake task which makes this a one-step process.
```
$ (cd boxes/base && rake install)
```

This will download the installation media for all supported operating
systems, perform a non-interactive installation, build Vagrant box
packages (in the boxes/base directory) and install those packages into
Vagrant.

You can free up some disk space afterwards by deleting the Vagrant box
package files, or you can keep them around to install them elsewhere.
```
$ (cd boxes/base && rake destroy)
```

OpenStack Cloud Controller
--------------------------

The OpenStack cloud controller includes a self-contained installation
of OpenStack, much like [devstack](http://devstack.org/) but is entirely
provisioned via Puppet.  The cloud controller provides Horizon, a web-based
management interface for OpenStack at http://cloud.puppetize.net.

Try it out locally by starting the "cloud" box.
```
$ (cd boxes/cloud && vagrant up)
```

When Vagrant has finished provisioning the box, open
[http://localhost:8080/horizon](http://localhost:8080/horizon) in a web
browser and log in using the username "admin" and password "changeme".

Other Vagrant Boxes
-------------------

There are other Vagrant boxes in the ```boxes``` directory, such as
"devstack", which aren't part of the main infrastructure but are used
for development.  Each Vagrantfile normally contains the provisioning
instructions or the name of the top-level Puppet class which defines its
role.  Take a look and modify them, or add boxes as you wish.

Test-Driven Development
-----------------------

Execute the main RSpec test suite using the top-level Rake task "spec".
This will perform some testing on the important Vagrant boxes, such as
the "cloud" box.
```
$ rake spec
/usr/bin/ruby1.9.1 -S rspec ./spec/boxes/cloud_spec.rb ./spec/boxes/vagrant_spec.rb -c -fd
Run options: exclude {:basebox=>#<Proc:./spec/support/vagrant.rb:8>}

Vagrant box 'cloud'
  with any basebox
    running OpenStack Dashboard
      presents a login screen

Vagrant box 'vagrant'
  with any basebox
    has a Vagrant 1.0.x executable in PATH
    has a "vagrant basebox" command (VeeWee)

Finished in 1 minute 30.5 seconds
3 examples, 0 failures
```

Continuous integration is provided by Travis CI, but is currently limited
and doesn't include these Vagrant box tests.

[![Build Status](https://travis-ci.org/puppetize/infrastructure.png)](https://travis-ci.org/puppetize/infrastructure)
