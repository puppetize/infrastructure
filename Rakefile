# Import all Rake tasks.

$LOAD_PATH.unshift Dir.pwd

Dir.glob('lib/tasks/*.rake').each { |file| import file }

task :default => :spec
