# High-level Rake tasks for the "puppetize.net" infrastructure

namespace :puppetize do
  desc "Install OpenStack as a cloud controller"
  task :cloud do |t|
    f = Tempfile.new('manifest')
    f.write File.read('manifests/cloud.pp')
    f.close
    puppet_apply f.path
  end

  desc "Set up Puppet editor support in Vim (system-wide)"
  task :vim do |t|
    puppet_apply_class 'site::vim::puppet'
  end
end
