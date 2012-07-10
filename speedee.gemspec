#-*-ruby-*-

$:.push File.expand_path("../lib", __FILE__)

require 'speedee/version'

Gem::Specification.new do |s|
  s.name = 'speedee'
  s.version = Speedee::VERSION
  s.date = `date +%Y-%m-%d`

  s.summary = 'A web-based MUA for Notmuch'
  s.description = 'Shows mail in a Notmuch mailbox'

  s.author = 'Pete Keen'
  s.email = 'pete@bugsplat.info'

  s.require_paths = %w< lib >

  s.bindir        = 'bin'
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- test/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.test_files = s.files.select {|path| path =~ /^test\/.*.rb/ }

  s.add_development_dependency('rake')
  s.add_development_dependency('rspec')

  s.add_dependency('sinatra')
  s.add_dependency('mail')
  
  s.homepage = 'https://github.com/peterkeen/speedee'
end
