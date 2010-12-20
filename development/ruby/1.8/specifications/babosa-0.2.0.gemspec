# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{babosa}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Norman Clarke"]
  s.date = %q{2010-08-29}
  s.description = %q{    A library for creating slugs. Babosa an extraction and improvement of the
    string code from FriendlyId, intended to help developers create similar
    libraries or plugins.
}
  s.email = %q{norman@njclarke.com}
  s.files = ["lib/babosa/characters.rb", "lib/babosa/identifier.rb", "lib/babosa/utf8/active_support_proxy.rb", "lib/babosa/utf8/dumb_proxy.rb", "lib/babosa/utf8/java_proxy.rb", "lib/babosa/utf8/mappings.rb", "lib/babosa/utf8/proxy.rb", "lib/babosa/utf8/unicode_proxy.rb", "lib/babosa/version.rb", "lib/babosa.rb", "README.md", "MIT-LICENSE", "Rakefile", "init.rb", "test/babosa_test.rb"]
  s.homepage = %q{http://norman.github.com/babosa}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{[none]}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{A library for creating slugs.}
  s.test_files = ["test/babosa_test.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
