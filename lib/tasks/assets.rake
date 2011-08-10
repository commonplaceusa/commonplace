
namespace :assets do
  desc 'runs Jammit for javascripts and stylesheets'
  task :update => :environment do
    Sass::Plugin.update_stylesheets
    `bundle exec jammit --force config/assets.yml --base_url "http://www.ourcommonplace.com/"`
  end

  def minify(files)
    files.each do |file|
      cmd = "java -jar lib/yuicompressor-2.3.1.jar #{file} -o #{file}"
      puts cmd
      ret = system(cmd)
      raise "Minification failed for #{file}" if !ret
    end
  end

  desc "minify"
  task :minify => [:minify_js, :minify_css]

  desc "minify javascript"
  task :minify_js do
    minify(FileList['public/javascripts/**/*.js'])
  end

  desc "minify css"
  task :minify_css do
    minify(FileList['public/stylesheets/**/*.css'])
  end

end
