require 'bundler/setup'
require 'daemons'

Daemons.run(File.join(__dir__, 'watcher.rb'))
