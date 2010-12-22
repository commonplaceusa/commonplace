source :gemcutter

gem "rails", "2.3.9"
gem "pg"
gem 'subdomain-fu'
gem 'nested_layouts'
gem 'aasm'
gem 'authlogic'
gem 'compass'
gem 'haml'
gem 'formtastic'
gem 'paperclip'
gem "acts-as-taggable-on"
gem "RedCloth"
gem "acts-as-list", :require =>"acts_as_list"
gem "glebm-geokit", :require => "geokit"
gem "cancan"
gem "friendly_id"
gem "tlsmail"
gem "resque"
gem "SystemTimer", :require => "system_timer"
gem 'exceptional'
gem 'aasm'
group :production do
gem 'unicorn'
end

group :development do 
  gem "factory_girl"
  gem "forgery"
  
  gem "capistrano"
  gem "capistrano-ext"#, :lib => false
  gem 'mongrel'
end

group :test do
  gem "rspec"#, :lib => false, :version => ">= 1.2.0"
  gem "rspec-rails"#, :lib => false, :version => ">= 1.2.0"
  gem "factory_girl"
  gem "forgery"
  gem "rr"
  gem "database_cleaner"
end

