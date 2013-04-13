begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec)

  task :test => :spec
rescue LoadError => e
  warn "#{e.class}: #{e.message}"
end
