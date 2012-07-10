begin
  require 'notmuch'
rescue LoadError => e
  raise "Please install the notmuch ruby bindings."
end

module Speedee; end

require 'speedee/config'
require 'speedee/app'
