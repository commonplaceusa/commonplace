web: bundle exec rails server thin -p $PORT
worker: QUEUE=* bundle exec rake resque:work --trace
forgot_password_worker: QUEUE=password_resets bundle exec rake resque:work --trace
delayed_job_worker: bundle exec rake jobs:work
clock: bundle exec rake resque:scheduler
sunspot: bundle exec rake sunspot:solr:run
