task :production do
  role :web, "69.164.215.169"
  role :app, "69.164.215.169"
  role :db,  "69.164.215.169", :primary => true
  set :web_server, :nginx
  set :nginx_conf_dir, '/etc/nginx/conf'
  set :domain, "commonplace.co cambridge.commonplace.co"
  set :web_port, "80"
end

task :staging do
  role :web, "69.164.212.22"
  role :app, "69.164.212.22"
  role :db,  "69.164.212.22", :primary => true
  set :web_server, :nginx
  set :domain, "staging.commonplace.in cambridge.staging.commonplace.in"
  set :web_port, "80"
end
