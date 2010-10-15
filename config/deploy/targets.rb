task :production do
  role :web, "69.164.212.22"
  role :app, "69.164.212.22"
  role :db,  "69.164.212.22", :primary => true
  set :web_server, :nginx
  set :nginx_conf_dir, '/etc/nginx/conf'
  set :domain, "westroxbury.commonplaceusa.com westroxbury.ourcommonplace.com"
  set :web_port, "80"
  set :rails_env, "production"
  set :branch, "origin/pre-launch"
end

task :staging do
  role :web, "69.164.215.169"
  role :app, "69.164.215.169"
  role :db,  "69.164.215.169", :primary => true
  set :web_server, :nginx
  set :domain, "staging.commonplace.co yourtown.ourcommonplace.com yourtown.commonplaceusa.com"
  set :web_port, "80"
  set :rails_env, "production"
  set :branch, "origin/master"
end
