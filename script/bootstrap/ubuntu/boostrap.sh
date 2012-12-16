sudo apt-get install -y ruby1.8-dev ruby1.8 ri1.8 rdoc1.8 irb1.8
sudo apt-get install -y libreadline-ruby1.8 libruby1.8 libopenssl-ruby
sudo apt-get install -y libxslt-dev libxml2-dev
sudo apt-get install -y g++
sudo apt-get install -y libmysqlclient-dev libmysqlclient16
sudo apt-get install -y libpq-dev postgresql
sudo apt-get install -y libmagickwand-dev imagemagick libmagickcore-dev
sudo apt-get install -y sqlite3 libsqlite3-dev


sudo -u postgres createuser --superuser $USER
createdb $USER
sudo -u postgres createuser --superuser commonplace
createdb commonplace_development
createdb commonplace_test
createdb commonplace_tmp

bundle install

mkdir -p ~/.heroku/plugins
heroku plugins:install git://github.com/ddollar/heroku-config.git
