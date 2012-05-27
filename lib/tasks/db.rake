# NOTE: Do not use this to overwrite heroku_san tasks
# Tasks defined here will execute after heroku_san
namespace :heroku do
  namespace :db do
    task :clone_to_staging do
      url = `heroku pgbackups:url --app commonplace`
      `heroku pgbackups:restore DATABASE "#{url}" --app commonplace-staging`
    end
  end
end
