require 'tempfile'
require 'tmpdir'
require 'yaml'

desc "Render README.md to HTML for preview (requires redcarpet)"
file 'README.html' => 'README.md' do |task|
  require 'rubygems'
  gem 'redcarpet'
  require 'redcarpet'
  include Redcarpet

  puts "Rendering README.md => README.html..."
  File.open('README.html', 'w') do |file|
    file.write(Markdown.new(Render::HTML).render(File.read("README.md")))
  end
end

# List essential boxes here.
boxes = ['puppet']

namespace :vagrant do
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

def git_update
  old_head = `git rev-parse HEAD`
  #unless system('git fetch && git reset origin/master && git clean -ffd && git reset --hard >/dev/null && git submodule update --init')
  unless system('git pull --ff-only && git clean -ffd && git submodule update --init')
    raise "Failed to update Git repository; last exit status was #{$?.exitstatus}"
  end
  new_head = `git rev-parse HEAD`
  return old_head != new_head
end

desc "Run \"git pull\" and update virtual machines"
task :update do
  if git_update
    vagrant_up(boxes)
    vagrant_provision(boxes)
  end
end

def puppet_apply manifest, options=nil
  Dir.mktmpdir do |confdir|
    command = %W{puppet apply --confdir=#{confdir} --modulepath=#{Dir.pwd}/modules}
    command += options unless options.nil?
    command << manifest
    command.unshift 'sudo' unless Process.uid == 0

    # Generate a Hiera configuration file.
    hiera_config = YAML.load_file('hiera.yaml')
    hiera_config[:yaml] ||= {}
    hiera_config[:yaml][:datadir] = File.join(Dir.pwd, 'data')
    f = File.new(File.join(confdir, 'hiera.yaml'), 'w')
    f.write(hiera_config.to_yaml)
    f.close

    begin
      unless system(*command)
        manifest = manifest.split("\n").join("\n  ")
        raise "Could not apply the Puppet manifest:\n  #{manifest}\n" + \
          "Command #{command.inspect} returned exit status #{$?.exitstatus}."
      end
    ensure
      command = %W{rm -rf #{confdir}/ssl}
      command.unshift 'sudo' unless Process.uid == 0
      system(*command)
    end
  end
end

def puppet_apply_class puppet_class
  f = Tempfile.new('manifest')
  f.write "include #{puppet_class}"
  f.close
  puppet_apply f.path
end

namespace :puppetize do
  desc "Turn this node into a Vagrant host"
  task :host do |t|
    f = Tempfile.new('manifest')
    f.write File.read('manifests/host.pp')
    f.close
    puppet_apply f.path
  end

  namespace :host do
    task :noop do |t|
      f = Tempfile.new('manifest')
      f.write File.read('manifests/host.pp')
      f.close
      puppet_apply f.path, %w{--noop}
    end
  end

  desc "Set up Puppet editor support in Vim (system-wide)"
  task :vim do |t|
    puppet_apply_class 'site::vim::puppet'
  end
end
