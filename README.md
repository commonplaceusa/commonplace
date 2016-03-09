Welcome to CommonPlace
======================

Getting Started
---------------

1.  Install and setup Git
2.  Install `docker`, `docker-machine` (if on OS X), and `docker-compose`.
3.  Run `./bin/bootstrap_docker.sh` and follow its instructions. You can log in with the user `test@example.com` and password `password`

Development Workflow
--------------------

To run standard commands in Docker, prefix them with `docker-compose run web `. For example: 

- To run the test suite, run `docker-compose run rake`
- To launch the Rails console, run `docker-compose run rails c`

Staging
-------

[commonplace-staging.herokuapp.com](http://commonplace-staging.herokuapp.com) is the URL for staging hosted on Heroku (there are also personal stagings - they do not have Sunspot available).

Set the remote with `git remote add staging git@heroku.com:commonplace-staging.git`

Push to staging with `git push -f staging`

Push a branch to staging with `git push -f staging branch-name:master`

TDD
---

It's nice to have reasonable assurrance that you didn't bork something by making a simple change or git merge. That's why we <3 tests. Write them to conform to the spec before you start writing the feature, and write the feature to conform to the tests. Anything going into master should pass all test cases, and all new code should be tested to the hilt.

