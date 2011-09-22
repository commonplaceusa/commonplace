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

guard 'spork' do
  watch('config/application.rb')
  watch('config/environment.rb')
  watch(%r{^config/environments/.*\.rb$})
  watch(%r{^config/initializers/.*\.rb$})
  watch('spec/spec_helper.rb')
end


guard 'rspec', cli: "--colour --drb --format Fuubar" do
  watch('spec/spec_helper.rb') { "spec" }

  watch('config/routes.rb') { "spec/routing" }

  watch('app/controllers/application_controller.rb') { "spec/controllers" }

  watch(%r{^spec/.+_spec\.rb$})

  watch(%r{^app/(.+)\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }

  watch(%r{^lib/(.+)\.rb$}) { |m| "spec/lib/#{m[1]}_spec.rb" }

  watch(%r{^app/controllers/(.+)_(controller)\.rb$}) do |m| 
    ["spec/routing/#{m[1]}_routing_spec.rb", 
     "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", 
     "spec/acceptance/#{m[1]}_spec.rb"] 
  end
end
