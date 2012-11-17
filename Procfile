web: bundle exec unicorn -p $PORT -c ./config/unicorn.rb
worker: bundle exec rake environment resque:work QUEUE=* READ_ONLY_DATABASE=true --trace
notification_worker: bundle exec rake environment resque:work QUEUE=notifications READ_ONLY_DATABASE=true
forgot_password_worker: bundle exec rake environment resque:work QUEUE=password_resets
rss_import_worker: bundle exec rake environment resque:work QUEUE=rss_importer
clock: bundle exec rake resque:scheduler
sunspot: bundle exec rake sunspot:solr:run
