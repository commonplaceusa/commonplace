require 'resque/tasks'
require 'resque_scheduler/tasks'

task "resque:scheduler_setup" => :environment # load the env so we know about the job classes

task "resque:setup" => :environment

namespace :resque do 
  task :restart_workers => :environment do
    system("sudo god restart resque-workers")
  end
end