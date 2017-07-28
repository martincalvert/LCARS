FROM ruby:2.4

ADD . /srv/lcars

WORKDIR /srv/lcars

RUN bundle install

CMD ['bash']
