web: bundle exec rails server thin -p $PORT
worker: QUEUE=* bundle exec rake resque:work --trace
forgot_password_worker: bundle exec rake environment resque:work QUEUE=password_resets
delayed_job_worker: bundle exec rake jobs:work
clock: bundle exec rake resque:scheduler
sunspot: bundle exec rake sunspot:solr:run
