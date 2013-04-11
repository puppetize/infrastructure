# Rake tasks and functions related to Puppet

require 'tempfile'
require 'tmpdir'
require 'yaml'

require 'lib/tasks/utils'

namespace :puppet do

  desc "Install Puppet (preferrably as a gem)"
  task :install do
    # Skip this task if a "puppet" executable is found in PATH.
    unless which('puppet')
      sudo %{gem install puppet}
      unless which('puppet')
        fail %{can't find "puppet" executable in PATH}
      end
    end
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
      puts command.join(' ')
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
