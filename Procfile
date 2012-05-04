web: bundle exec rails server thin -p $PORT
worker: bundle exec rake environment resque:work QUEUE=* --trace
notification_worker: bundle exec rake environment resque:qork QUEUE=notifications
forgot_password_worker: bundle exec rake environment resque:work QUEUE=password_resets
rss_import_worker: bundle exec rake environment resque:work QUEUE=rss_importer
clock: bundle exec rake resque:scheduler
sunspot: bundle exec rake sunspot:solr:run
