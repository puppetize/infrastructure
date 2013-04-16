require 'puppetize/vagrant'

module Puppetize

  module Vagrant

    module Config

      DEFAULT_BASEBOX = Puppetize::Vagrant.baseboxes_for_host.select {
        # Use an Ubuntu distribution as the default basebox.
        |basebox| basebox =~ /^quantal/
      }.first

      BASEBOX = ENV['BASEBOX'] || DEFAULT_BASEBOX

      def self.run(rake_task, basebox = BASEBOX, &block)
        ::Vagrant::Config.run do |config|
          # Every Vagrant virtual environment requires a box to build
          # off of.
          config.vm.box = basebox

          # Enable the "Hardware clock in UTC time" setting because the
          # base image is configured to expect the hardware clock to be
          # in UTC time, and because that's the traditional Unix way as
          # well.
          #
          # See https://github.com/mitchellh/vagrant/issues/912.
          config.vm.customize ["modifyvm", :id, "--rtcuseutc", "on"]

          # Mount the whole infrastructure as a shared folder.
          config.vm.share_folder "v-infra", "/home/vagrant/infrastructure", "../.."

          # Apply ../../manifests/cloud.pp with Hiera data from ../../data.
          config.vm.provision :shell, :inline => \
            "cd /home/vagrant/infrastructure && rake #{rake_task}"

          # Further configuration can be done in the actual Vagrantfile.
          yield config if block_given?
        end
      end

    end

  end

end
