ENVIRONMENTS = {
  :production => "commonplace",
  :staging    => "commonplace-staging"
}

namespace :deploy do
  ENVIRONMENTS.keys.each do |env|
    desc "Deploy to #{env}"
    task env do
      current_branch = `git branch | grep ^* | awk '{ print $2 }'`.strip

      Rake::Task['deploy:before_deploy'].invoke(env, current_branch)
      Rake::Task['deploy:update_code'].invoke(env, current_branch)
      Rake::Task['deploy:after_deploy'].invoke(env, current_branch)
    end
  end

  task :before_deploy, :env, :branch do |t, args|
    puts "Making sure we are in sync with Github"
    Rake::Task['git:push'].invoke(args[:branch])
    puts "Deploying #{args[:branch]} to #{args[:env]}"
  end

  task :after_deploy, :env, :branch do |t, args|
    puts "Deployment Complete"
  end

  task :update_code, :env, :branch do |t, args|
    FileUtils.cd Rails.root do
      puts "Updating #{ENVIRONMENTS[args[:env]]} with branch #{args[:branch]}"
      `git push +github:#{ENVIRONMENTS[args[:env]]} +#{args[:remote]}:#{args[:branch]}`
    end
  end
end

namespace :git do
  desc "Push to Github"
  task :push do
    current_branch = `git branch | grep ^* | awk '{ print $2 }'`.strip
    `git push github #{current_branch}`
  end

  desc "Add Github and Heroku remotes"
  task :setup do
    `git remote add github git@github.com:commonplaceusa/commonplace.git`
    ENVIRONMENTS.each do |env,remote|
      `git remote add #{env} git@heroku.com:#{remote}.git`
    end
  end
end
