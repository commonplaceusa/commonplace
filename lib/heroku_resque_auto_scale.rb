require 'heroku'

if !Rails.env.production? and false
  module HerokuResqueAutoScale
  end
else
  module HerokuResqueAutoScale
    module Scaler
      class << self
        @@heroku = Heroku::Client.new(ENV['HEROKU_USER'], ENV['HEROKU_PASSWORD'])

        def workers
          @@heroku.ps(ENV['HEROKU_APP']).count { |a| a["process"] =~ /worker/ }
        end

        def workers=(qty)
          @@heroku.ps_scale(ENV['HEROKU_APP'], :type=>'worker', :qty=>qty)
        end

        def job_count
          Resque.info[:pending].to_i
        end
      end
    end

    def after_perform_scale_up(*args)
      Logger.new(STDERR).debug "Scaling..."
      [
       {
         :workers => 1, # This many workers
         :job_count => 1 # For this many jobs or more, until the next level
       },
       {
         :workers => 2,
         :job_count => 15
       },
       {
         :workers => 3,
         :job_count => 25
       },
       {
         :workers => 4,
         :job_count => 40
       },
       {
         :workers => 5,
         :job_count => 60
       }
      ].reverse_each do |scale_info|
        # Run backwards so it gets set to the highest value first
        # Otherwise if there were 70 jobs, it would get set to 1, then 2, then 3, etc

        # If we have a job count greater than or equal to the job limit for this scale info
        if Scaler.job_count >= scale_info[:job_count]
          # Set the number of workers unless they are already set to a level we want. Don't scale down here!
          if Scaler.workers <= scale_info[:workers]
            Logger.new(STDERR).info "Scaling to #{scale_info[:workers]} workers"
            Scaler.workers = scale_info[:workers]
            Logger.new(STDERR).info "...Done!"
          end
          break # We've set or ensured that the worker count is high enough
        end
      end
    end
  end
end
