# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{forgery}
  s.version = "0.3.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Nathan Sutton"]
  s.date = %q{2010-10-22}
  s.description = %q{Easy and customizable generation of forged data. Can be used as a gem or a rails plugin. Includes rails generators for creating your own forgeries.}
  s.email = %q{nate@sevenwire.com}
  s.files = ["generators/forgery/forgery_generator.rb", "generators/forgery/USAGE", "lib/forgery/dictionaries/cities", "lib/forgery/dictionaries/colors", "lib/forgery/dictionaries/company_names", "lib/forgery/dictionaries/continents", "lib/forgery/dictionaries/countries", "lib/forgery/dictionaries/country_code_top_level_domains", "lib/forgery/dictionaries/female_first_names", "lib/forgery/dictionaries/frequencies", "lib/forgery/dictionaries/genders", "lib/forgery/dictionaries/job_title_suffixes", "lib/forgery/dictionaries/job_titles", "lib/forgery/dictionaries/languages", "lib/forgery/dictionaries/last_names", "lib/forgery/dictionaries/locations", "lib/forgery/dictionaries/lorem_ipsum", "lib/forgery/dictionaries/male_first_names", "lib/forgery/dictionaries/name_suffixes", "lib/forgery/dictionaries/name_titles", "lib/forgery/dictionaries/province_abbrevs", "lib/forgery/dictionaries/provinces", "lib/forgery/dictionaries/races", "lib/forgery/dictionaries/shirt_sizes", "lib/forgery/dictionaries/state_abbrevs", "lib/forgery/dictionaries/states", "lib/forgery/dictionaries/street_suffixes", "lib/forgery/dictionaries/streets", "lib/forgery/dictionaries/top_level_domains", "lib/forgery/dictionaries/zones", "lib/forgery/dictionaries.rb", "lib/forgery/extensions/array.rb", "lib/forgery/extensions/hash.rb", "lib/forgery/extensions/range.rb", "lib/forgery/extensions/string.rb", "lib/forgery/file_reader.rb", "lib/forgery/forgery/address.rb", "lib/forgery/forgery/basic.rb", "lib/forgery/forgery/date.rb", "lib/forgery/forgery/internet.rb", "lib/forgery/forgery/lorem_ipsum.rb", "lib/forgery/forgery/monetary.rb", "lib/forgery/forgery/name.rb", "lib/forgery/forgery/personal.rb", "lib/forgery/forgery/time.rb", "lib/forgery/forgery.rb", "lib/forgery/forgery_api.rb", "lib/forgery/forgery_railtie.rb", "lib/forgery/formats/phone", "lib/forgery/formats/street_number", "lib/forgery/formats/zip", "lib/forgery/formats.rb", "lib/forgery/version.rb", "lib/forgery.rb", "lib/generators/forgery/forgery_generator.rb", "LICENSE", "README.markdown", "Rakefile"]
  s.homepage = %q{http://github.com/sevenwire/forgery}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{forgery}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Easy and customizable generation of forged data.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 0"])
    else
      s.add_dependency(%q<rspec>, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 0"])
  end
end
