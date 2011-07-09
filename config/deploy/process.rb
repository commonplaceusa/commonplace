namespace :deploy do
  task :start do
  end
  task :stop do
  end
  
  desc "Display staging logs"
  task :tail_staging_logs, :roles => :app do
    run "tail -f #{shared_path}/logs/staging.log" do |channel, stream, data|
      puts  # for an extra line break before the host name
      puts "#{channel[:host]}: #{data}" 
      break if stream == :err    
    end
  end

  desc "Restart the application"    
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "kill -USR2 `cat #{shared_path}/pids/unicorn.pid`"
  end

  namespace :web do
    task :setup, :roles => :app do
      eval("deploy.#{web_server.to_s}.setup")
    end
    
    task :restart, :roles => :app do
      eval("deploy.#{web_server.to_s}.restart")
    end
  end
end
after "deploy:setup", "deploy:web:restart"
