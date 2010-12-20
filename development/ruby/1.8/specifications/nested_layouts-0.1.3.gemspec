# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{nested_layouts}
  s.version = "0.1.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Sunteya"]
  s.date = %q{2009-10-18}
  s.email = %q{Sunteya@gmail.com}
  s.extra_rdoc_files = ["README.textile"]
  s.files = [".gitignore", "README.textile", "Rakefile", "VERSION.yml", "init.rb", "lib/nested_layouts.rb", "rails/inti.rb"]
  s.homepage = %q{http://github.com/sunteya/nested_layouts}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Plugin allows to specify outer layouts for particular layout thus creating nested layouts.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<actionpack>, [">= 2.3"])
    else
      s.add_dependency(%q<actionpack>, [">= 2.3"])
    end
  else
    s.add_dependency(%q<actionpack>, [">= 2.3"])
  end
end
