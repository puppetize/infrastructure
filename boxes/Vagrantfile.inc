# -*- mode: ruby -*-
# vi: set ft=ruby :

module Puppetize
  module Vagrant
    module Config
      module Quantal
        def self.run(&block)
          ::Vagrant::Config.run do |config|
            # Every Vagrant virtual environment requires a box to build
            # off of.  We choose an architecture here that works best with
            # the host operating system.
            host_is_64bit = ['a'].pack('P').length > 4
            config.vm.box = host_is_64bit ? "quantal64" : "quantal32"

            # Enable the "Hardware clock in UTC time" setting because the
            # base image is configured to expect the hardware clock to be
            # in UTC time, and because that's the traditional Unix way as
            # well.
            #
            # See https://github.com/mitchellh/vagrant/issues/912.
            config.vm.customize ["modifyvm", :id, "--rtcuseutc", "on"]

            # Mount the whole infrastructure as a shared folder.
            config.vm.share_folder "v-infra", "/home/vagrant/infrastructure", "../.."

            # Further configuration is done in the actual Vagrantfile.
            yield config
          end
        end
      end
    end
  end
end
