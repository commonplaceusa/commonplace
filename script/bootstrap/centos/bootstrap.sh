# Install GCC + tools
# Install RVM

sudo yum update -y
# Ruby dependencies
sudo yum install -y gcc-c++ patch readline readline-devel zlib zlib-devel libyaml-devel libffi-devel openssl-devel make bzip2 autoconf automake libtool bison iconv-devel
# SQLite dependencies
sudo yum install -y sqlite-devel
# Nokogiri dependencies
sudo yum install -y gcc ruby-devel libxml2 libxml2-devel libxslt libxslt-devel
# PostgreSQL dependencies
sudo yum install -y postgresql9*
# PostgreSQL setup
sudo service postgresql initdb
sudo service postgresql start

# ImageMagick setup
sudo yum install -y ImageMagick ImageMagick-devel

# Redis setup
wget http://redis.googlecode.com/files/redis-2.2.7.tar.gz
tar xzf redis-2.2.7.tar.gz
cd redis-2.2.7
make
sudo make install
sudo cp ./redis.conf /etc/
cd ../
rm -rf redis-2.2.7
redis-server > /dev/null &

# Prompt the user to set up their database
echo "You must now set up your PostgreSQL database"
echo "Run: $ sudo su - postgres"
echo "$ psql template1"
echo "# CREATE USER <<your user name>> WITH PASSWORD '';"
echo "# CREATE DATABASE commonplace_development;"
echo "# GRANT ALL PRIVILEGES ON DATABASE commonplace_development TO <<your user name>>;"
echo "# ALTER USER <<your user name>> CREATEDB;"
echo "# \q"
echo "$ exit"
echo "$ sudo vi /var/lib/pgsql9/data/pg_hba.conf"
echo "REPLACE 'ident' with 'trust' and save"
echo "service postgresql restart"

# Install necessary packages
#bundle install

# Set up the database
#bundle exec rake db:setup

# Run the test suite
