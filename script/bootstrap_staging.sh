USER=$1;
EMAIL=$2;
heroku create --stack cedar commonplace-staging-$USER;
heroku addons:add releases --app commonplace-staging-$USER;
heroku addons:add redistogo:nano --app commonplace-staging-$USER;
heroku addons:add memcache:5mb --app commonplace-staging-$USER;
heroku addons:add custom_error_pages --app commonplace-staging-$USER;
heroku addons:add cron:daily --app commonplace-staging-$USER;
heroku addons:add pgbackups --app commonplace-staging-$USER;

heroku labs:enable user_env_compile --app commonplace-staging-$USER;

git remote add personal-staging-$USER git@heroku.com:commonplace-staging-$USER.git;
git push personal-staging-$USER master;

heroku pgbackups:restore DATABASE `heroku pgbackups:url --app commonplace` --app commonplace-staging-$USER --confirm commonplace-staging-$USER;

heroku config:add ERROR_PAGE_URL=https://s3.amazonaws.com/commonplace-heroku-pages/maintenance.html --app commonplace-staging-$USER;
heroku config:add S3_KEY_ID=**removed** --app commonplace-staging-$USER;
heroku config:add S3_KEY_SECRET=**removed** --app commonplace-staging-$USER;
heroku config:add facebook_app_id=**removed** --app commonplace-staging-$USER;
heroku config:add facebook_app_secret=**removed** --app commonplace-staging-$USER;
heroku config:add facebook_password=staging --app commonplace-staging-$USER;
heroku config:add facebook_salt=**removed** --app commonplace-staging-$USER;
heroku config:add metrics_server=localhost --app commonplace-staging-$USER;

heroku run rake sunspot:reindex --app commonplace-staging-$USER;

heroku sharing:add $EMAIL --app commonplace-staging-$USER;

heroku restart --app commonplace-staging-$USER; 
