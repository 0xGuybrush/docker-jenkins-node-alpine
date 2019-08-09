FROM 'anotherdave/docker-jenkins-node-alpine:0.0.4'

USER root
RUN apk update
# cf. https://github.com/andrius/alpine-ruby
RUN apk add --no-cache \
	ruby-dev \
	build-base \
	libxml2-dev libxslt-dev pcre-dev libffi-dev \
	postgresql-dev

RUN rm /var/cache/apk/*
COPY .gemrc /home/jenkins/.gemrc
RUN gem install bundler
RUN gem install foreman
USER jenkins
