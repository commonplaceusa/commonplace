rails_env   = ENV['RAILS_ENV']  || "production"
rails_root  = ENV['RAILS_ROOT'] || "/home/deploy/commonplace/current"
num_workers = 1

num_workers.times do |num|
  God.watch do |w|
    w.name     = "resque-#{num}"
    w.group    = 'resque-workers'
    w.interval = 30.seconds
    w.env      = {"QUEUE"=>"*", "RAILS_ENV"=>rails_env}
    w.start    = "/usr/bin/rake -f #{rails_root}/Rakefile environment resque:work"
    w.stop_signal = 'QUIT'
    
    w.uid = 'deploy'
    w.gid = 'deploy'

    # retart if memory gets too high
    w.transition(:up, :restart) do |on|
      on.condition(:memory_usage) do |c|
        c.above = 350.megabytes
        c.times = 2
      end
    end

    # determine the state on startup
    w.transition(:init, { true => :up, false => :start }) do |on|
      on.condition(:process_running) do |c|
        c.running = true
      end
    end

    # determine when process has finished starting
    w.transition([:start, :restart], :up) do |on|
      on.condition(:process_running) do |c|
        c.running = true
        c.interval = 5.seconds
      end

      # failsafe
      on.condition(:tries) do |c|
        c.times = 5
        c.transition = :start
        c.interval = 5.seconds
      end
    end

    # start if process is not running
    w.transition(:up, :start) do |on|
      on.condition(:process_running) do |c|
        c.running = false
      end
    end
  end
end
