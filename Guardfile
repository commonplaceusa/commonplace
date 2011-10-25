# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'bundler' do
  watch('Gemfile')
  # Uncomment next line if Gemfile contain `gemspec' command
  # watch(/^.+\.gemspec/)
end

guard 'jslint-on-rails' do
  # watch for changes to application javascript files
  watch(%r{^app/javascripts/.*\.js$})
  # watch for changes to the JSLint configuration
  watch('config/jslint.yml')
end
