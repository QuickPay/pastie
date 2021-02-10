FROM ruby:2.7

COPY . /root/pastie
WORKDIR /root/pastie

RUN gem install bundler:1.15.4 && bundle install

CMD bundle exec unicorn -c config/unicorn-docker.rb -E production
