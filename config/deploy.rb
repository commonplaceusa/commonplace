lib_path = File.expand_path(File.join(File.dirname(__FILE__), "deploy"))
# basics
load "#{lib_path}/settings.rb"
load "#{lib_path}/helpers.rb"
 
# deployment tasks
load "#{lib_path}/setup.rb"
load "#{lib_path}/gems.rb"
load "#{lib_path}/deploy.rb"
load "#{lib_path}/symlinks.rb"
load "#{lib_path}/process.rb"
load "#{lib_path}/nginx.rb"

# load deployment targets
load "#{lib_path}/targets.rb"



 # Add RVM's lib directory to the load path.
$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
puts File.expand_path('./lib', ENV['rvm_path'])
require "rvm/capistrano" 
