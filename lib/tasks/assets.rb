require 'jammit'
namespace :assets do
  desc 'runs Jammit for javascripts and stylesheets'
  task :update => :environmentdo
    Sass::Plugin.update_stylesheets
    Jammit.package!
  end
end
