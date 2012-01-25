guard 'bundler', :notify => false do
  # Install gems on demand
  watch('Gemfile')
end

guard 'jslint-on-rails' do
  # watch for changes to application javascript files
  watch(%r{^app/javascripts/.*\.js$})
  # watch for changes to the JSLint configuration
  watch('config/jslint.yml')
end

guard 'sass', :input => 'sass', :output => 'css'
