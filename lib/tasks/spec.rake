begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec) do |t|
    t.rspec_opts = '-c -fd'
  end

  task :test => :spec
rescue LoadError => e
  warn "#{e.class}: #{e.message}"
end
