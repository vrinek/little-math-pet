require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "little-math-pet"
  gem.homepage = "http://github.com/vrinek/little-math-pet"
  gem.license = "MIT"
  gem.summary = %Q{Parses math expressions and returns the result}
  gem.description = %Q{LittleMathPet understands simple math expressions in string format with mutliple variables and returns the result of the expression}
  gem.email = "kostas.karachalios@me.com"
  gem.authors = ["Kostas Karachalios"]

  gem.add_development_dependency 'rspec', '~> 2.5.0'
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "little-math-pet #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

require 'rake/testtask'
Rake::TestTask.new(:spec) do |test|
  test.libs << 'lib'
  test.pattern = 'specs/**/*_spec.rb'
  test.verbose = true
end
task :default => :spec