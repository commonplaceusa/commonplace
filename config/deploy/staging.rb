
set :application, "staging.commonplace.in"
set :deploy_to, "/home/staging/commonplace"
set :user, "staging"

role :app, "staging.commonplace.in"
role :web, "staging.commonplace.in"
role :db, "staging.commonplace.in"

