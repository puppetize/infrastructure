# High-level Rake tasks for the "puppetize.net" infrastructure

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
