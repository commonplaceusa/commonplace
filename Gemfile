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

group :development, :test do
  gem "factory_girl"
  gem "ZenTest"
  gem "forgery"
  gem "rspec-rails", "~> 1.3"
  gem "rspec", "~> 1.3"
  gem "autotest-rails"
end

group :development do 
  gem "capistrano"
  gem "capistrano-ext"#, :lib => false
  gem 'mongrel'
end

group :test do
  gem "rr"
  gem "database_cleaner"
end

