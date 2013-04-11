# Rake tasks and functions related to Vagrant

# List essential boxes here.
boxes = ['puppet']

namespace :vagrant do
  desc "Install Vagrant using Puppet"
  task :install => "puppet:install" do
    # Skip this task if a "vagrant" executable is found in PATH.
    unless which('vagrant')
      puppet_apply_class 'site::vagrant'
    end
  end

  desc "Start Vagrant boxes #{boxes.inspect}"
  task :up do
    vagrant_up(boxes)
  end

  desc "Stop Vagrant boxes #{boxes.inspect}"
  task :halt do
    vagrant_halt(boxes)
  end
end

def vagrant_up(boxes)
  boxes.each do |box|
    Dir.chdir("boxes/#{box}") do
      puts "Starting Vagrant box '#{box}'"
      unless system('vagrant up')
        raise "Failed to start #{box} box: 'vagrant up' returned #{$?.exitstatus}"
      end
    end
  end
end

def vagrant_halt(boxes)
  boxes.each do |box|
    Dir.chdir("boxes/#{box}") do
      puts "Stopping Vagrant box '#{box}'"
      unless system('vagrant halt')
        raise "Failed to stop #{box} box: 'vagrant halt' returned #{$?.exitstatus}"
      end
    end
  end
end

def vagrant_provision(boxes)
  boxes.each do |box|
    Dir.chdir("boxes/#{box}") do
      puts "Provisioning Vagrant box '#{box}'"
      unless system('vagrant provision')
        raise "Failed to provision #{box} box: 'vagrant provision' returned #{$?.exitstatus}"
      end
    end
  end
end
