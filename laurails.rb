require_relative 'lib/laurails'
require_relative 'config/routes'

Laurails.root = File.expand_path(File.dirname(__FILE__))

Laurails.run
