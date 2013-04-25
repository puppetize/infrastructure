begin
  require 'rspec/core/rake_task'

  desc "Run RSpec code examples (excluding vagrant boxes)"
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.rspec_opts = '-c -fd -t ~vagrant'
  end

  namespace :spec do

    desc "Run RSpec code examples for vagrant boxes"
    RSpec::Core::RakeTask.new(:boxes) do |t|
      t.rspec_opts = '-c -fd -t vagrant'
    end

  end
rescue LoadError => e
  warn "#{e.class}: #{e.message}"
end
