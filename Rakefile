require 'bundler/gem_tasks'
require 'rake/testtask'

Rake::TestTask.new do |t|
  %w[lib spec].each do |dir|
    t.libs.push File.join(File.dirname(__FILE__), dir)
  end

  t.pattern = "spec/**/*_spec.rb"
end
task :spec => [:test]
task :default => [:test]
