# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{exceptional}
  s.version = "2.0.32"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Contrast"]
  s.date = %q{2010-12-16}
  s.default_executable = %q{exceptional}
  s.description = %q{Exceptional is the Ruby gem for communicating with http://getexceptional.com (hosted error tracking service). Use it to find out about errors that happen in your live app. It captures lots of helpful information to help you fix the errors.}
  s.email = %q{hello@contrast.ie}
  s.executables = ["exceptional"]
  s.files = ["lib/exceptional/alert_data.rb", "lib/exceptional/application_environment.rb", "lib/exceptional/catcher.rb", "lib/exceptional/config.rb", "lib/exceptional/controller_exception_data.rb", "lib/exceptional/exception_data.rb", "lib/exceptional/integration/alerter.rb", "lib/exceptional/integration/dj.rb", "lib/exceptional/integration/rack.rb", "lib/exceptional/integration/rack_rails.rb", "lib/exceptional/integration/rails.rb", "lib/exceptional/integration/sinatra.rb", "lib/exceptional/integration/tester.rb", "lib/exceptional/log_factory.rb", "lib/exceptional/monkeypatches.rb", "lib/exceptional/rack_exception_data.rb", "lib/exceptional/railtie.rb", "lib/exceptional/remote.rb", "lib/exceptional/startup.rb", "lib/exceptional/version.rb", "lib/exceptional.rb", "lib/tasks/exceptional_tasks.rake", "spec/bin/ginger", "spec/dj_integration_spec.rb", "spec/exceptional/alert_exception_data_spec.rb", "spec/exceptional/catcher_spec.rb", "spec/exceptional/config_spec.rb", "spec/exceptional/controller_exception_data_spec.rb", "spec/exceptional/exception_data_spec.rb", "spec/exceptional/monkeypatches_spec.rb", "spec/exceptional/rack_exception_data_spec.rb", "spec/exceptional/remote_spec.rb", "spec/exceptional/startup_spec.rb", "spec/exceptional_rescue_spec.rb", "spec/fixtures/exceptional.yml", "spec/fixtures/exceptional_disabled.yml", "spec/fixtures/exceptional_old.yml", "spec/fixtures/favicon.png", "spec/ginger_scenarios.rb", "spec/rack_integration_spec.rb", "spec/rails_integration_spec.rb", "spec/rails_rack_integration_spec.rb", "spec/spec_helper.rb", "spec/standalone_spec.rb", "rails/init.rb", "init.rb", "install.rb", "exceptional.gemspec", "bin/exceptional"]
  s.homepage = %q{http://getexceptional.com/}
  s.require_paths = ["lib"]
  s.requirements = ["json_pure, json-jruby or json gem required"]
  s.rubyforge_project = %q{exceptional}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{getexceptional.com is a hosted service for tracking errors in your Ruby/Rails/Rack apps}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rack>, [">= 0"])
    else
      s.add_dependency(%q<rack>, [">= 0"])
    end
  else
    s.add_dependency(%q<rack>, [">= 0"])
  end
end
