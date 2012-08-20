require 'spec/rake/spectask'
require 'rake/gempackagetask'
task :default =>  [ :spec, :gem ]
Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
end
gem_spec = Gem::Specification.new do |s|
  s.name = "fantasy_football_nerd"
  s.version = "0.9.0"
  s.authors = ["Greg Baugues"]
  s.date = %q{2012-08-20}
  s.description = 'Fantasy Football Nerd API wrapper'
  s.summary = s.description
  s.email = 'greg@baugues.com'
  s.files = ['README.md', 'lib/fantasy_football_nerd.rb','spec/fantasy_football_nerd_spec.rb']
  s.homepage = 'http://www.baugues.com'
  s.has_rdoc = false
  s.rubyforge_project = 'fantasy_football_nerd'
  s.add_dependency('hashie')
  s.add_dependency('nokogiri')
  s.rubyforge_project = 'fantasy_football_nerd'
end

Rake::GemPackageTask.new( gem_spec ) do |t|
  t.need_zip = true
end

task :push => :gem do |t|
  sh "gem push pkg/#{gem_spec.name}-#{gem_spec.version}.gem"
end
