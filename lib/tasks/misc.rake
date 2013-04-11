# Miscellaneous Rake tasks

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
