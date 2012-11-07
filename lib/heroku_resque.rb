module HerokuResque
  class WorkerScaler
    @queue = :server_management

    def self.perform(num_dynos)
      Heroku::Client.new(ENV['HEROKU_USER'], ENV['HEROKU_PASSWORD']).ps_scale(ENV['HEROKU_APP'], :type => 'worker', :qty => num_dynos)
    end

    def self.count(type)
      Heroku::Client.new(ENV['HEROKU_USER'], ENV['HEROKU_PASSWORD']).ps(ENV['HEROKU_APP']).select { |ps| ps["process"].include? type }.count
    end
  end

  class NotificationWorkerScaler < WorkerScaler
    def self.perform(num_dynos)
      Heroku::Client.new(ENV['HEROKU_USER'], ENV['HEROKU_PASSWORD']).ps_scale(ENV['HEROKU_APP'], :type => 'notification_worker', :qty => num_dynos)
    end
  end

  class WebScaler < WorkerScaler
    def self.perform(num_dynos)
      Heroku::Client.new(ENV['HEROKU_USER'], ENV['HEROKU_PASSWORD']).ps_scale(ENV['HEROKU_APP'], :type => 'web', :qty => num_dynos)
    end
  end

end
