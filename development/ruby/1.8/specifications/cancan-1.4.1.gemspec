# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{cancan}
  s.version = "1.4.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.4") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ryan Bates"]
  s.date = %q{2010-11-12}
  s.description = %q{Simple authorization solution for Rails which is decoupled from user roles. All permissions are stored in a single location.}
  s.email = %q{ryan@railscasts.com}
  s.files = ["lib/cancan/ability.rb", "lib/cancan/active_record_additions.rb", "lib/cancan/can_definition.rb", "lib/cancan/controller_additions.rb", "lib/cancan/controller_resource.rb", "lib/cancan/exceptions.rb", "lib/cancan/inherited_resource.rb", "lib/cancan/matchers.rb", "lib/cancan/query.rb", "lib/cancan.rb", "spec/cancan/ability_spec.rb", "spec/cancan/active_record_additions_spec.rb", "spec/cancan/can_definition_spec.rb", "spec/cancan/controller_additions_spec.rb", "spec/cancan/controller_resource_spec.rb", "spec/cancan/exceptions_spec.rb", "spec/cancan/inherited_resource_spec.rb", "spec/cancan/matchers_spec.rb", "spec/cancan/query_spec.rb", "spec/matchers.rb", "spec/spec.opts", "spec/spec_helper.rb", "CHANGELOG.rdoc", "Gemfile", "LICENSE", "Rakefile", "README.rdoc", "init.rb"]
  s.homepage = %q{http://github.com/ryanb/cancan}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{cancan}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Simple authorization solution for Rails.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, ["~> 2.0.0.beta.22"])
      s.add_development_dependency(%q<rails>, ["~> 3.0.0"])
      s.add_development_dependency(%q<rr>, ["~> 0.10.11"])
      s.add_development_dependency(%q<supermodel>, ["~> 0.1.4"])
    else
      s.add_dependency(%q<rspec>, ["~> 2.0.0.beta.22"])
      s.add_dependency(%q<rails>, ["~> 3.0.0"])
      s.add_dependency(%q<rr>, ["~> 0.10.11"])
      s.add_dependency(%q<supermodel>, ["~> 0.1.4"])
    end
  else
    s.add_dependency(%q<rspec>, ["~> 2.0.0.beta.22"])
    s.add_dependency(%q<rails>, ["~> 3.0.0"])
    s.add_dependency(%q<rr>, ["~> 0.10.11"])
    s.add_dependency(%q<supermodel>, ["~> 0.1.4"])
  end
end
