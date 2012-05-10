last_cmd = ''

def run(cmd)
  last_cmd = cmd
  last_output = `#{cmd}`; $?.success?
end

def success(msg)
  puts "SUCCESS: #{msg}"
end

def failure(msg)
  puts "FAILURE: #{msg}"
  puts "LAST COMMAND: #{last_cmd}"
end

def action(msg)
  puts "ACTION: #{msg}"
end

namespace :deployment do
  desc 'Deploy master to production'
  task :production => :environment do
    if run("bundle exec rspec")
      success "Passed tests"
      action "Syncing with Github"
      if run("git push origin master")
        success "In sync with Github"
        action "Pushing to production"
        if run("git push production master")
          success "Pushed successfully"
          $statsd.increment("deploys")
        else
          failure "Could not push to Heroku"
        end
      else
        failure "Could not sync with Github"
      end
    else
      failure "Failed test suite"
    end
  end
end
