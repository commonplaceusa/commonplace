
namespace :assets do
  desc 'runs Jammit for javascripts and stylesheets'
  task :update => :environment do
    Sass::Plugin.update_stylesheets
    `bundle exec jammit --force config/assets.yml`
  end
end
