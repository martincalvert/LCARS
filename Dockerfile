FROM ruby:2.4
MAINTAINER martinlcalvert@gmail.com

COPY Gemfile Gemfile.lock ./
RUN bundle config --global frozen 1 && bundle install
COPY . /srv/lcars

WORKDIR /srv/lcars

CMD ['bash']
