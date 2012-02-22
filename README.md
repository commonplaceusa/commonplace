Welcome to CommonPlace
====

CommonPlace is a Social Networking Site that includes everything needed to create
database-backed civic infrastructure according to the Model-View-Control pattern.

This pattern splits the view (also called the presentation) into "dumb"
templates that are primarily responsible for inserting pre-built data in between
HTML tags. The model contains the "smart" domain objects (such as Account,
Product, Person, Post) that holds all the business logic and knows how to
persist themselves to a database. The controller handles the incoming requests
(such as Save New Account, Update Product, Show Post) by manipulating the model
and directing data to the view.

In Rails, the model is handled by what's called an object-relational mapping
layer entitled Active Record. This layer allows you to present the data from
database rows as objects and embellish these data objects with business logic
methods. You can read more about Active Record in
link:files/vendor/rails/activerecord/README.html.

The controller and view are handled by the Action Pack, which handles both
layers by its two parts: Action View and Action Controller. These two layers
are bundled in a single package due to their heavy interdependence. This is
unlike the relationship between the Active Record and Action Pack that is much
more separate. Each of these packages can be used independently outside of
Rails. You can read more about Action Pack in
link:files/vendor/rails/actionpack/README.html.

Getting Started
----

1.  Install and setup Git
2.  Install RVM, and setup an installation of Ruby (1.9.2, or 1.9.3 if you want the tests to pass)
3.  Follow the steps in `rvm notes`
4.  Install Gem
5.  `git clone git@github.com:commonplaceusa/commonplace.git`
6.  `cd commonplace`
7.  `gem install bundler`
8. If on OSX, install Homebrew
9.  Install Redis
  * `sudo apt-get install redis-server`
  * `brew install redis`

10.  Install ImageMagick
  * `sudo apt-get install imagemagick libmagick9-dev`

11. Install Postgres
  * `sudo apt-get install postgresql libpq-dev`
  * `brew install postgres`

12. Install MongoDB
  * `sudo apt-get install mongodb`
  * `brew install mongodb`

13. `bundle install`
14. `cp config/database.yml.example config/database.yml`
15. Authenticate for the database
  * `sudo su postgres`
  * `createuser `username
16. Add the initial test community with `bundle exec rake db:setup`

Run mongodb with `sudo start mongodb`

Run the server with `bundle exec foreman start` or `bundle exec rails s thin`

Run sunspot with `bundle exec sunspot-solr run`
And reindex with `bundle exec rake sunspot:solr:reindex`

Go to [http://localhost:5000/test](http://localhost:5000/test) and login with test@example.com:password

Staging
----

[commonplace-staging.herokuapp.com](http://commonplace-staging.herokuapp.com) is the URL for staging hosted on Heroku (there are also personal stagings - they do not have Sunspot available).

Set the remote with `git remote add staging git@heroku.com:commonplace-staging.git`

Push to staging with `git push -f staging`

Push a branch to staging with `git push -f staging branch-name:master`

TDD
----

It's nice to have reasonable assurrance that you didn't bork something by making a simple change or git merge. That's why we <3 tests. Write them to conform to the spec before you start writing the feature, and write the feature to conform to the tests. Anything going into master should pass all test cases, and all new code should be tested to the hilt.

