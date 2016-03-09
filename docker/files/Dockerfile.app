FROM ruby:2.1.5
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs npm nodejs-legacy
RUN apt-get install -y imagemagick libmagick-dev

RUN mkdir /commonplace

WORKDIR /tmp
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install

ADD . /commonplace
WORKDIR /commonplace
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
