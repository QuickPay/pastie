FROM ruby:2.7

ADD . /root/pastie
RUN cd root/pastie && gem install bundler:1.15.4 && bundle install
