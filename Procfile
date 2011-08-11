web: bundle exec rails server thin -p $PORT
worker: QUEUE=* bundle exec rake resque:work --trace
worker: bundle exec rake jobs:work
clock: bundle exec rake resque:scheduler
