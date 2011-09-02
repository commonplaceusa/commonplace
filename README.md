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
2.  Install RVM, and setup an installation of Ruby (1.9.2 or 1.9.3)
3.  Install Gem
4.  `git clone git@github.com:commonplaceusa/commonplace.git`
5.  `cd commonplace`
6.  `gem install bundler`
7.  Install Redis
8.  Install ImageMagick 
9.  Install Postgres
10. Install Jetty
11. `bundle install`
12. `cp config/database.yml.example config/database.yml`
13. `bundle exec rake db:setup`

Run the server with `bundle exec foreman start`

Go to [http://localhost:5000/test](http://localhost:5000/test) and login with test@example.com:password
