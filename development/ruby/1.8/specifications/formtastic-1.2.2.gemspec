# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{formtastic}
  s.version = "1.2.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Justin French"]
  s.date = %q{2010-11-28}
  s.description = %q{A Rails form builder plugin/gem with semantically rich and accessible markup}
  s.email = %q{justin@indent.com.au}
  s.extra_rdoc_files = ["README.textile"]
  s.files = ["generators/form/form_generator.rb", "generators/form/USAGE", "generators/formtastic/formtastic_generator.rb", "lib/formtastic/i18n.rb", "lib/formtastic/layout_helper.rb", "lib/formtastic/railtie.rb", "lib/formtastic/util.rb", "lib/formtastic.rb", "lib/generators/formtastic/form/form_generator.rb", "lib/generators/formtastic/install/install_generator.rb", "lib/generators/templates/_form.html.erb", "lib/generators/templates/_form.html.haml", "lib/generators/templates/formtastic.css", "lib/generators/templates/formtastic.rb", "lib/generators/templates/formtastic_changes.css", "lib/locale/en.yml", "rails/init.rb", "MIT-LICENSE", "README.textile", "init.rb"]
  s.homepage = %q{http://github.com/justinfrench/formtastic/tree/master}
  s.post_install_message = %q{
  ========================================================================
  Thanks for installing Formtastic!
  ------------------------------------------------------------------------
  You can now (optionally) run the generator to copy some stylesheets and
  a config initializer into your application:
    rails generate formtastic:install # Rails 3
    ./script/generate formtastic      # Rails 2

  To generate some semantic form markup for your existing models, just run:
    rails generate formtastic:form MODEL_NAME # Rails 3
    ./script/generate form MODEL_NAME         # Rails 2

  Find out more and get involved:
    http://github.com/justinfrench/formtastic
    http://groups.google.com.au/group/formtastic
  ========================================================================
  }
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{A Rails form builder plugin/gem with semantically rich and accessible markup}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, [">= 2.3.7"])
      s.add_runtime_dependency(%q<actionpack>, [">= 2.3.7"])
      s.add_runtime_dependency(%q<i18n>, [">= 0.4.0"])
      s.add_development_dependency(%q<rails>, [">= 3.0.0"])
      s.add_development_dependency(%q<rspec-rails>, ["~> 2.0.0"])
      s.add_development_dependency(%q<rspec_tag_matchers>, [">= 1.0.0"])
      s.add_development_dependency(%q<hpricot>, ["~> 0.8.3"])
    else
      s.add_dependency(%q<activesupport>, [">= 2.3.7"])
      s.add_dependency(%q<actionpack>, [">= 2.3.7"])
      s.add_dependency(%q<i18n>, [">= 0.4.0"])
      s.add_dependency(%q<rails>, [">= 3.0.0"])
      s.add_dependency(%q<rspec-rails>, ["~> 2.0.0"])
      s.add_dependency(%q<rspec_tag_matchers>, [">= 1.0.0"])
      s.add_dependency(%q<hpricot>, ["~> 0.8.3"])
    end
  else
    s.add_dependency(%q<activesupport>, [">= 2.3.7"])
    s.add_dependency(%q<actionpack>, [">= 2.3.7"])
    s.add_dependency(%q<i18n>, [">= 0.4.0"])
    s.add_dependency(%q<rails>, [">= 3.0.0"])
    s.add_dependency(%q<rspec-rails>, ["~> 2.0.0"])
    s.add_dependency(%q<rspec_tag_matchers>, [">= 1.0.0"])
    s.add_dependency(%q<hpricot>, ["~> 0.8.3"])
  end
end
