# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{glebm-geokit}
  s.version = "1.5.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Andre Lewis and Bill Eisenhauer, with fixes from Krzysztof Knapik"]
  s.date = %q{2010-05-18}
  s.description = %q{Geokit Gem (glebm's fork)}
  s.email = ["andre@earthcode.com / bill_eisenhauer@yahoo.com"]
  s.extra_rdoc_files = ["Manifest.txt", "README.markdown"]
  s.files = ["Manifest.txt", "README.markdown", "Rakefile", "lib/geokit/geocoders.rb", "lib/geokit.rb", "lib/geokit/mappable.rb", "test/test_base_geocoder.rb", "test/test_bounds.rb", "test/test_ca_geocoder.rb", "test/test_geoloc.rb", "test/test_google_geocoder.rb", "test/test_latlng.rb", "test/test_multi_geocoder.rb", "test/test_us_geocoder.rb", "test/test_yahoo_geocoder.rb", "test/test_geoplugin_geocoder.rb", "test/test_google_reverse_geocoder.rb", "test/test_inflector.rb", "test/test_ipgeocoder.rb", "test/test_multi_ip_geocoder.rb"]
  s.homepage = %q{http://github.com/glebm/geokit-gem}
  s.rdoc_options = ["--main", "README.markdown"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{geokit}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{none}
  s.test_files = ["test/test_base_geocoder.rb", "test/test_bounds.rb", "test/test_ca_geocoder.rb", "test/test_geoloc.rb", "test/test_geoplugin_geocoder.rb", "test/test_google_geocoder.rb", "test/test_google_reverse_geocoder.rb", "test/test_inflector.rb", "test/test_ipgeocoder.rb", "test/test_latlng.rb", "test/test_multi_geocoder.rb", "test/test_multi_ip_geocoder.rb", "test/test_us_geocoder.rb", "test/test_yahoo_geocoder.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
