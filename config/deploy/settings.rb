set :application, "commonplace"
default_run_options[:pty] = true
set :scm, :git
set :repository,  "git@github.com:commonplaceusa/#{application}.git"
set :uses_ssl, false
set :normal_symlinks, %w(
  config/database.yml
  config/config.yml
  config/unicorn.rb
  config/crypto.yml
)
set :bin_path, "/usr/local/rvm/gems/ree-1.8.7-2010.02/bin"
set :weird_symlinks, {
  "system"             => "public/system",
  "logs"               => "log"
}
set :user, "deploy"


