require 'resque/tasks'

task "resque:setup" => :environment

namespace :resque do 
  task :restart_workers => :environment do
    system("sudo god restart resque-workers")
  end
end