require 'resque/tasks'
require 'resque_scheduler/tasks'

task "resque:scheduler_setup" => :environment # load the env so we know about the job classes

task "resque:setup" => :environment do
  Resque.before_fork do |job| 
    ActiveRecord::Base.establish_connection 
  end
end

namespace :resque do 
  task :restart_workers => :environment do
    system("sudo god restart resque-workers")
  end
end