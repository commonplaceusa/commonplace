Autotest.add_hook :initialize do |at|
  at.add_exception 'development'
  at.add_exception 'app/stylesheets'
  at.add_exception 'test'
end
Autotest.add_discovery { "rspec" }
