$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "speedee/version"
require 'rake'

def sys(cmd)
  system(cmd) or raise "Error running #{cmd}"
end

task :spec do
  sys "rspec specs/*spec.rb"
end

task :build => :spec do
  sys "gem build speedee.gemspec"
end
 
task :release => :build do
  sys "git tag -a -m 'tag version #{Speedee::VERSION}' v#{Speedee::VERSION}"
  sys "git push origin master --tags"
  sys "git push github master --tags"
  sys "gem push speedee-#{Speedee::VERSION}.gem"
end

