set :application, "commonplace"
default_run_options[:pty] = true
set :branch, "origin/master"
set :scm, :git
set :repository,  "git@github.com:maxtilford/#{application}.git"
set :uses_ssl, false
set :normal_symlinks, %w(
  config/database.yml
  config/config.yml
)
set :weird_symlinks, {
  "system"             => "public/system",
  "logs"               => "log"
}
set :user, "deploy"
set :deploy_to, "/home/#{user}/#{application}"

